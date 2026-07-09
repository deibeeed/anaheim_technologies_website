# CI/CD reference — `.github/workflows/main.yaml`

Verified against the repo 2026-07-07 (HEAD `95e1d9d`). This is the single source
of automated build + deploy for the website. There is exactly one workflow file
and one job.

## Identity & triggers

```yaml
name: ci-deploy
on:
  push:            { branches: [master] }
  pull_request:    { branches: [master] }
  workflow_dispatch:
concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true
```

- Runs on any **push to `master`**, any **PR targeting `master`**, and manual
  **Run workflow** (`workflow_dispatch`).
- `concurrency` cancels an in-progress run for the same ref when a newer one
  starts (so rapid pushes to `master` don't stack deploys).

## The job: `build-and-deploy` (runs-on `ubuntu-latest`)

| # | Step | Command / action |
|---|---|---|
| 1 | Checkout | `actions/checkout@v4` |
| 2 | Set up Flutter | `subosito/flutter-action@v2` with `flutter-version: '3.41.6'`, `channel: 'stable'`, `cache: true` |
| 3 | Install dependencies | `flutter pub get` |
| 4 | Generate localizations | `flutter gen-l10n` |
| 5 | Analyze (errors only) | `flutter analyze --no-fatal-warnings --no-fatal-infos` |
| 6 | Build web (production) | `flutter build web --release -t lib/main_production.dart` |
| 7 | Deploy LIVE | `FirebaseExtended/action-hosting-deploy@v0`, **only if** `github.event_name == 'push' \|\| github.event_name == 'workflow_dispatch'` |
| 8 | Deploy PREVIEW | `FirebaseExtended/action-hosting-deploy@v0`, **only if** `github.event_name == 'pull_request' && head repo == this repo` |

Notes:

- CI calls **bare `flutter`** (not `fvm flutter`) — `subosito/flutter-action`
  installs SDK 3.41.6 and puts it on PATH. This is correct in CI only; locally
  use `fvm flutter` (there is no system Flutter on the dev machine).
- CI passes **no `--flavor`** and **no `--dart-define=ENVIRONMENT`**. That is why
  the deployed build has an empty `ENVIRONMENT` and writes to the unprefixed
  `inquiries` collection (see `references/entrypoints-and-environment.md`).
- **No `flutter test` step exists.** Adding one is tracked by
  `ato-website-testing-and-cleanup`.

## Deploy action inputs

Both deploy steps use the same action and secrets; they differ only in whether a
`channelId` is set.

```yaml
# Step 7 — LIVE (push / workflow_dispatch)
with:
  repoToken: ${{ secrets.GITHUB_TOKEN }}
  firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_ANAHEIM_TECHNOLOGIES }}
  projectId: anaheim-technologies
  channelId: live            # <-- deploys to production

# Step 8 — PREVIEW (same-repo PR)
with:
  repoToken: ${{ secrets.GITHUB_TOKEN }}
  firebaseServiceAccount: ${{ secrets.FIREBASE_SERVICE_ACCOUNT_ANAHEIM_TECHNOLOGIES }}
  projectId: anaheim-technologies
  # no channelId -> action creates/updates an ephemeral preview channel and
  # comments the preview URL on the PR
```

- `channelId: live` = production Hosting channel.
- Omitting `channelId` on the PR step = a temporary preview channel; the action
  posts the preview URL as a PR comment. Preview channels expire on their own.
- **Fork PRs are skipped** by the `head.repo.full_name == github.repository`
  guard (forks cannot read the service-account secret).

## Secrets (GitHub repo → Settings → Secrets and variables → Actions)

| Secret | Purpose |
|---|---|
| `GITHUB_TOKEN` | auto-provided by Actions; lets the deploy action comment the preview URL on PRs |
| `FIREBASE_SERVICE_ACCOUNT_ANAHEIM_TECHNOLOGIES` | JSON key of a service account with Firebase Hosting deploy rights on project `anaheim-technologies` |

If `FIREBASE_SERVICE_ACCOUNT_ANAHEIM_TECHNOLOGIES` is missing/expired, the deploy
steps fail; the build steps (2–6) still run and gate PRs. Whether the secret is
currently valid is **not checkable from the repo** — verify in GitHub settings +
the Firebase console.

## History: the analyze-gate relax

`git show 2816a39` (website repo, "ci: relax analyze gate to errors only",
2026-04-30, David + Claude Opus 4.7): changed step 5 from
`--no-fatal-infos` to `--no-fatal-warnings --no-fatal-infos` so pre-existing
unused-import **warnings** stop blocking deploy. Only true compile errors fail
the gate now. The unused imports are named in SKILL.md; cleaning them so the gate
can be re-tightened is `ato-website-testing-and-cleanup`'s job.

## Re-verify

```bash
cat .github/workflows/main.yaml
git show 2816a39 -- .github/workflows/main.yaml
```
