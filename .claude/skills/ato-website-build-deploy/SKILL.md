---
name: ato-website-build-deploy
description: >-
  Use when building, running, or deploying the Anaheim Technologies marketing
  website (Flutter web) — reproducing the CI build locally, setting up the
  fvm-pinned toolchain, or shipping a change. Use when `flutter` is "command not
  found", when a push to master did (or did not) reach the live site, when a PR
  preview channel is expected, when a Firebase Hosting deploy to
  `anaheim-technologies` fails, or when you need to know what `main_development`
  vs `main_production` vs the `ENVIRONMENT` dart-define actually change.
---

# ato-website build & deploy

The runbook for compiling and shipping the Anaheim Technologies marketing site:
a Flutter **web-only** app (Firebase Hosting, project `anaheim-technologies`,
live at `https://anaheimtechnologies.com`). This is the PRIMARY HOME for the
toolchain, build/run/deploy commands, the CI/CD pipeline, the prod-only
single-project reality, and the known build-time traps.

## When NOT to use this skill (use a sibling in THIS repo)

- **lib/ structure, routing, blocs, responsive globals, Firebase init in Dart** →
  `ato-website-architecture`.
- **Content, pages, brand/fonts/colors, splash screen, l10n copy** →
  `ato-website-content-and-brand`.
- **Tests, the broken counter scaffold, removing mobile/Windows/es debt, adding a
  CI test step** → `ato-website-testing-and-cleanup`.
- **The contact-form → Firestore `inquiries` → email pipeline, the `dev_inquiries`
  gap, Firestore rules** → `ato-website-inquiries-and-integration`.

## Toolchain (as of 2026-07-07)

| Thing | Value | How to confirm |
|---|---|---|
| Flutter SDK manager | **fvm** (`/opt/homebrew/bin/fvm`, v4.0.4) | `fvm --version` |
| Pinned Flutter | **3.41.6** (Dart 3.11.4) via `.fvmrc` | `cat .fvmrc` → `{"flutter":"3.41.6"}` |
| SDK location | `.fvm/flutter_sdk` → `~/fvm/versions/3.41.6` | `readlink .fvm/flutter_sdk` |
| Lint ruleset | `very_good_analysis` 3.1.0 | `cat analysis_options.yaml` |
| Firebase CLI (deploy) | `firebase` v14.27.0 | `firebase --version` |
| Node (`.nvmrc`) | `v19.1.0` — only for `firebase-tools`; NO JS tooling lives in this repo | `cat .nvmrc` |

**There is NO system `flutter` or `dart` on PATH** (`which flutter` → not found).
**ALWAYS prefix `fvm`** — run `fvm flutter …` / `fvm dart …`, never bare
`flutter`. A bare `flutter` command will fail with "command not found"; if it
ever resolves, it is the wrong (unpinned) SDK. First thing to verify in a fresh
clone:

```bash
fvm flutter --version   # must print "Flutter 3.41.6 ... Dart 3.11.4"
```

(In CI the SDK is provisioned differently — `subosito/flutter-action` puts a
bare `flutter` 3.41.6 on PATH — so the CI YAML calls bare `flutter`. That is
correct **for CI only**; locally, always use `fvm flutter`.)

## Core commands (verified)

Run all from the repo root.

```bash
# 1. Resolve dependencies (pinned by pubspec.lock)
fvm flutter pub get

# 2. Regenerate localizations (l10n.yaml; outputs into lib/l10n/arb/, which is
#    tracked/committed — regenerate after editing any .arb).
fvm flutter gen-l10n

# 3. Run the dev flavor in Chrome (this is the everyday local command)
fvm flutter run -d chrome -t lib/main_development.dart \
  --dart-define=ENVIRONMENT=development

# 4. Build exactly what CI ships → output lands in build/web (gitignored)
fvm flutter build web --release -t lib/main_production.dart

# 5. Manual deploy of a local build to Firebase Hosting (needs `firebase login`
#    + build/web present). Normally you do NOT do this by hand — see "How
#    changes ship". Uses the default project from .firebaserc (anaheim-technologies).
firebase deploy --only hosting
```

`scripts/build-web.sh` chains steps 1–4 (the CI build) for you.

## The three `main_*.dart` entrypoints (they barely differ on web)

All three call `bootstrap()` (global `AppBlocObserver`, zoned error logging) and
render the same `App`. On web the practical differences are tiny:

| Entrypoint | Log level | `Firebase.initializeApp`? | Notes |
|---|---|---|---|
| `main_development.dart` | `Level.ALL` | yes | everyday local target |
| `main_production.dart` | `Level.WARNING` | yes | **what CI builds & deploys** |
| `main_staging.dart` | (none) | **NO** | minimal stub — does not init Firebase, so the contact form's Firestore write cannot succeed under this target. Not used by CI or the VSCode/IntelliJ prod path. Prefer dev or production. |

`--flavor` (development/staging/production) exists in the run configs but is an
Android/iOS concept; the web build (CI and step 4 above) passes **no** `--flavor`
and it is irrelevant to the deployed artifact. Full detail:
`references/entrypoints-and-environment.md`.

## The `ENVIRONMENT` dart-define inconsistency (intended, benign)

`String.fromEnvironment('ENVIRONMENT')` is read in two places; the only one that
changes behavior is the contact form's Firestore collection prefix
(`lib/features/contact_us/bloc/contact_us_bloc.dart`: `development` → `dev_`
prefix, anything else → unprefixed `inquiries`).

**Who passes the define:**

| Launch path | Passes `--dart-define=ENVIRONMENT`? |
|---|---|
| IntelliJ `.idea/runConfigurations/development.xml` | `=development` |
| IntelliJ `production.xml` | `=production` (also `--web-renderer html`) |
| IntelliJ `staging.xml` | none |
| `.vscode/launch.json` (all 3) | **none** |
| CI (`.github/workflows/main.yaml`) | **none** |

So **the deployed build has an empty `ENVIRONMENT`.** Empty `!= 'development'`,
so the prod build writes to the unprefixed `inquiries` collection — which is
exactly the collection the Cloud Functions trigger watches. This is the intended
prod path, not a bug. The full explanation of why `dev_inquiries` never triggers
email lives in `ato-website-inquiries-and-integration` (do not duplicate it here).

## How changes ship (this repo has no separate change-control doc — this is it)

There is one workflow: `.github/workflows/main.yaml` (`ci-deploy`). It is the
only deploy path you should use.

- **Push to `master` → deploys LIVE.** A merge/push to `master` auto-builds and
  deploys to the `live` Hosting channel — i.e. straight to production
  `anaheimtechnologies.com`. There is no manual approval gate.
- **Open a PR against `master` (same repo) → preview channel.** The same build
  deploys to an ephemeral preview channel and the action comments the preview
  URL on the PR. **Use PRs to eyeball a change before it goes live.** PRs from
  forks are skipped (no secret access).
- **`workflow_dispatch`** (manual "Run workflow") → also deploys LIVE.

CI steps, in order: `checkout` → `subosito/flutter-action@v2` (3.41.6, stable,
cached) → `flutter pub get` → `flutter gen-l10n` → `flutter analyze
--no-fatal-warnings --no-fatal-infos` → `flutter build web --release -t
lib/main_production.dart` → deploy via `FirebaseExtended/action-hosting-deploy@v0`
to project `anaheim-technologies`.

**There is NO `flutter test` step** (the tests are broken scaffold; a test gate
is wanted once real tests exist — see `ato-website-testing-and-cleanup`). Secrets
used: `GITHUB_TOKEN`, `FIREBASE_SERVICE_ACCOUNT_ANAHEIM_TECHNOLOGIES`. Full
step-by-step, trigger conditions, and secret-provisioning notes:
`references/ci-cd.md`.

### The analyze gate is deliberately errors-only

Commit `2816a39` (website repo, "ci: relax analyze gate to errors only") changed
the CI analyze step from `--no-fatal-infos` to
`--no-fatal-warnings --no-fatal-infos` so that **pre-existing unused-import
warnings do not block deploy.** Only true compile errors fail the gate. The
offending imports are still present (verified 2026-07-07, all with zero usages):

- `lib/features/services/screen/services_screen.dart` — `import 'dart:math' as math;`, `import 'package:url_launcher/url_launcher_string.dart';`
- `lib/features/projects/screen/projects_screen.dart` — same two unused imports
- `lib/utils/constants.dart` — `import 'package:intl/intl.dart';`

Fixing this lint debt (so the gate can be tightened back) is the cleanup skill's
job, not this one → `ato-website-testing-and-cleanup`.

## Environment reality (accepted)

**One Firebase project, `anaheim-technologies`, prod-only.** `.firebaserc` has a
single `default` project; `firebase.json` is hosting-only (`public: build/web`,
SPA rewrite `** → /index.html`; no `firestore.rules`, no `functions/` in this
repo). There is no separate dev/staging Firebase project. This is the accepted
reality — emulators are the local dev path. (The Firestore/inquiries and rules
posture belong to `ato-website-inquiries-and-integration`.)

## Traps

- **`firebase_options.dart` is web-only.** `currentPlatform` returns config only
  when `kIsWeb`; every other platform (`android`/`iOS`/`macOS`/`windows`/`linux`)
  `throw UnsupportedError`. Do not attempt a mobile/desktop build — it will throw
  at Firebase init. The `android/`, `ios/`, `windows/` scaffolds are vestigial
  (removable debt per the maintainer — see cleanup skill).
- **No system `flutter`/`dart`** — always `fvm flutter` (see Toolchain).
- **`build/` is gitignored** (0 tracked files); the site is rebuilt in CI, never
  committed. Do not commit `build/web`.
- **`main_staging.dart` does not init Firebase** — the contact form breaks under
  it. Use `main_development.dart` (or `main_production.dart`) locally.
- **`firebase deploy --only hosting` by hand ships to LIVE** using the default
  project. Prefer the PR-preview flow; only deploy by hand with intent.

## Provenance and maintenance

Authored **2026-07-07** from direct inspection of the repo at
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`
(git `master`, HEAD `95e1d9d`). Re-verify drift-prone facts:

```bash
cat .fvmrc                                   # pinned Flutter version
fvm flutter --version                        # actual SDK (expect 3.41.6 / Dart 3.11.4)
cat .github/workflows/main.yaml              # CI triggers, steps, analyze flags, channels, secrets
cat .firebaserc firebase.json                # single project + hosting-only config
git log --oneline -1 2816a39                 # the analyze-gate relax commit
# unused imports that keep the analyze gate at errors-only:
grep -nE "dart:math|url_launcher_string" lib/features/services/screen/services_screen.dart lib/features/projects/screen/projects_screen.dart
grep -n "package:intl/intl.dart" lib/utils/constants.dart
```

**Open/unverified:** whether the Firebase service-account secret and Hosting
target are still valid is not checkable from the repo (verify in the GitHub repo
settings + Firebase console). A full local `fvm flutter build web --release`
compiles the toolchain end-to-end but was not run to completion during authoring
(`fvm flutter pub get` was confirmed to resolve cleanly); run `scripts/build-web.sh`
to confirm the whole chain.
