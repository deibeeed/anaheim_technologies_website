# Cleanup backlog — per-item runbook

Depth for `SKILL.md` Part 3. The maintainer decided this app is **web-only for
good** (`human-answers.md` A2, 2026-07-07): the counter scaffold, empty Spanish
l10n, mobile/Windows scaffolds, and stale branches are removable debt; real
tests are wanted. Everything below is **decide-then-do** — confirm current state
with the evidence command, get sign-off for anything mutating a shared remote,
and land each item as its own reviewable change. Verified 2026-07-07.

`scripts/audit-cleanup.sh` runs the read-only checks for items 1-7 in one pass.

---

## 1. Dead `lib/counter/*` scaffold + its tests

**State:** `lib/counter/counter.dart`, `lib/counter/cubit/counter_cubit.dart`,
`lib/counter/view/counter_page.dart` exist but are referenced nowhere real.

**Verify:**
```sh
grep -rn "CounterPage\|CounterCubit\|counter/counter.dart" lib/main_*.dart lib/bootstrap.dart lib/app/
# expect: no matches. (The l10n string "counterAppBarTitle" is unrelated copy.)
```

**Do:** delete `lib/counter/`, `test/counter/`, and fix or delete
`test/app/view/app_test.dart` (it asserts `find.byType(CounterPage)` and will
not compile once `lib/counter/counter.dart` is gone). Do this in the same change
as Part 2's "replace the broken counter tests." Keep `test/helpers/`.

---

## 2. Empty Spanish l10n

**State:** `lib/l10n/arb/app_es.arb` contains only the boilerplate
`counterAppBarTitle` key; all real UI copy is hardcoded English string literals
in widgets. `l10n.yaml` sets `arb-dir: lib/l10n/arb`, template `app_en.arb`.

**Verify:**
```sh
cat lib/l10n/arb/app_es.arb   # only counterAppBarTitle
grep -rn "l10n\." lib/features/  # near-zero real localized lookups
```

**Do (pick one):**
- Drop it: delete `app_es.arb`, remove `es` from supported locales, re-run
  `fvm flutter gen-l10n`. Simplest, matches "web-only, English marketing site."
- Revive it: only if Spanish is actually wanted — then real copy must move out of
  widget literals into ARB keys first (large content refactor; coordinate with
  `ato-website-content-and-brand`).

Default recommendation: drop, since no copy is localized.

---

## 3. Vestigial `android/`, `ios/`, `windows/` scaffolds

**State:** full Very Good CLI platform scaffolds exist, but the app only ships
to Firebase Hosting (web). `firebase_options.dart` supports **web only** — every
other platform throws.

**Verify:**
```sh
grep -n "UnsupportedError" lib/firebase_options.dart   # android/iOS/macOS/windows/linux
grep -n "iOS, Android, Web, and Windows" README.md      # boilerplate claim, README:34
ls -d android ios windows 2>/dev/null
```

**Do:** remove the unused platform trees (`android/`, `ios/`, `windows/`, and
`macOS`/`linux` if present) and correct the README's "works on iOS, Android,
Web, and Windows" line to web-only. **Largest blast radius — do it last.**
Before deleting, confirm nothing in `pubspec.yaml` `flutter:` assets, the CI
workflow, or launcher-icon config depends on those directories. This is purely a
source-tree cleanup; it does not touch the deployed site (CI builds
`flutter build web`).

---

## 4. Stale branches + `go_router` pin

**State (as of 2026-07-07):** `git branch -r` shows 5 abandoned Dependabot
branches plus `origin/versions/2`:

```
origin/dependabot/pub/bloc_test-9.1.3
origin/dependabot/pub/flutter_bloc-8.1.3
origin/dependabot/pub/go_router-10.0.0
origin/dependabot/pub/url_launcher-6.1.11
origin/dependabot/pub/very_good_analysis-4.0.01
origin/versions/2
```

`pubspec.yaml:22` pins `go_router: ^6.5.2` while the open Dependabot branch
proposes 10.0.0 (~2 major versions behind).

**Verify:**
```sh
git branch -r
grep -n "go_router" pubspec.yaml
```

**Do:**
- Pruning remote branches is **mutating a shared remote** — get maintainer
  sign-off, then: `git push origin --delete dependabot/pub/bloc_test-9.1.3`
  (repeat per branch), and decide `versions/2` separately (it is 0 ahead / 9
  behind master per the dossier — likely safe to delete, but confirm with
  `git log origin/master..origin/versions/2`).
- Bump `go_router` deliberately (not by merging the stale bot PR): update the
  pin, run `fvm flutter pub get`, migrate any breaking API in `router_utils.dart`
  / `app.dart`, and verify with the analyze gate + the new tests. `go_router`
  6→10 has breaking changes; treat as a real migration, not a lockfile bump.
- These skills do **not** perform git mutations autonomously; propose and let the
  maintainer run them.

---

## 5. Orphaned `assets/under-construction*.png`

**State:** `assets/under-construction.png` and `assets/under-construction-2.png`
are unreferenced by any code.

**Verify:**
```sh
grep -rn "under-construction" lib/ web/ pubspec.yaml
# only hits: a commented-out flaticon attribution at lib/app/view/app.dart:129-130
```

**Do:** delete both PNGs. Optionally also remove the dead attribution comment at
`app.dart:129-130`. Assets are declared broadly (`assets:` includes `assets/`),
so no pubspec edit is required.

---

## 6. Committed Firebase hosting cache

**State:** `.firebase/hosting.YnVpbGQvd2Vi.cache` is tracked in git — deploy
cruft that should never be committed.

**Verify:**
```sh
git ls-files | grep "\.firebase/"
```

**Do:** `git rm --cached .firebase/hosting.YnVpbGQvd2Vi.cache` and add
`.firebase/` to `.gitignore`. (Hosting/deploy mechanics: `ato-website-build-deploy`.)

---

## 7. Unused imports (the analyze debt)

**State:** the CI analyze gate was relaxed to `--no-fatal-warnings
--no-fatal-infos` to tolerate pre-existing unused imports rather than fix them
(`ato-website-build-deploy` owns the gate's history). Directly confirmed unused:

- `import 'package:intl/intl.dart';` in `lib/utils/constants.dart:1` (class has
  only three bools).
- `import 'dart:math' as math;` and
  `import 'package:url_launcher/url_launcher_string.dart';` in **both**
  `lib/features/services/screen/services_screen.dart:7,10` and
  `lib/features/projects/screen/projects_screen.dart:7,10`.

**Verify (authoritative list):**
```sh
fvm flutter analyze          # lists every unused_import / warning
```

**Do:** remove the unused imports. Once the tree is clean you *could* tighten the
analyze gate back toward warnings-fatal — but that is the build-deploy skill's
call, not this one's. Also note the non-standard `snake_case`
`_firestore_collection_prefix` getter in `contact_us_bloc.dart:26` (an
`avoid_private_typedef_functions`/naming lint) if you do a lint sweep.

---

## 8. Missing LICENSE vs MIT badge

**State:** README shows an MIT license badge (`README.md:5`, links at
`:160-161`) but there is **no `LICENSE` file** in the repo.

**Verify:**
```sh
ls LICENSE 2>/dev/null || echo "no LICENSE"
grep -n "License: MIT\|license_link" README.md
```

**Do:** either add a real MIT `LICENSE` file (maintainer's call on the actual
license) or remove the badge. Do not leave the mismatch.

---

## Ordering suggestion

1. Items 1 + 7 + 5 + 6 — low-risk, local, do first (pairs naturally with the
   test cleanup in Part 2).
2. Item 2 (l10n) and item 8 (license) — small policy decisions.
3. Item 4 (branches + go_router bump) — needs remote sign-off + a real dep
   migration.
4. Item 3 (platform trees) — largest blast radius, do last.
