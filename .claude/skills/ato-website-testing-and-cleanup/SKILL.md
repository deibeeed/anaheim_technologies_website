---
name: ato-website-testing-and-cleanup
description: >-
  Use when writing, running, or wiring in Flutter tests for this marketing site
  (widget/integration tests, responsive/mobile/small-screen coverage,
  `flutter test`, coverage); when the broken counter tests fail or you notice CI
  never runs tests; when the coverage badge or MIT badge looks wrong; or when
  deciding whether to delete the counter scaffold, empty Spanish l10n,
  android/ios/windows scaffolds, orphaned assets, or stale Dependabot branches.
---

# ATO website: testing and cleanup

This skill covers two linked jobs for the `anaheim_technologies_website` Flutter
web app:

1. **Get to a real test suite** — the current `test/` tree is broken Very Good
   CLI boilerplate; replace it with widget tests that MUST cover
   responsive/mobile/small-screen layouts, then wire `flutter test` into CI.
2. **Work the sanctioned cleanup backlog** — the maintainer has decided this app
   is **web-only for good** (see `human-answers.md` A2, 2026-07-07). The
   counter scaffold, empty Spanish l10n, mobile/Windows scaffolds, and stale
   branches are removable debt. This skill lists them as a **decide-then-do
   checklist**, never silent deletion.

Verified against the repo on **2026-07-07**. Re-verify with the one-liners in
"Provenance and maintenance" before trusting anything volatile.

## When NOT to use this skill (use a sibling instead)

- **How the toolchain / build / CI / deploy works** (fvm 3.41.6, `fvm flutter`,
  the CI workflow steps, Firebase Hosting) → `ato-website-build-deploy`. This
  skill only *adds a test step* to that CI; it does not own the toolchain.
- **The architecture you are testing** — GoRouter/ShellRoute, the
  responsive-globals pattern, blocs/cubits, Firestore contact flow →
  `ato-website-architecture`. This skill cites the globals only as far as
  needed to test them; the primary explanation lives there.
- **Content/brand/how-to-add-a-page** → `ato-website-content-and-brand`.
- **The contact-form → Firestore → functions email pipeline and inquiries
  rules** → `ato-website-inquiries-and-integration`.

---

## Part 1 — Current testing state (as of 2026-07-07)

`test/` is stale Very Good CLI scaffold and **broken**. Do not trust it.

| File | Problem |
| --- | --- |
| `test/app/view/app_test.dart` | Asserts `find.byType(CounterPage)` (line 9). `App` renders a `GoRouter`/`HomeScreen` (`lib/app/view/app.dart:94-96`, initial route `/` → `HomeScreenContent`) and never a `CounterPage`. **This test fails if run.** |
| `test/counter/cubit/counter_cubit_test.dart` | Tests `lib/counter/cubit/counter_cubit.dart` — **dead scaffold**, referenced nowhere in `lib/` except itself (grep confirms no `CounterPage`/`CounterCubit` use in `main_*.dart`, `bootstrap.dart`, or `lib/app/`). |
| `test/counter/view/counter_page_test.dart` | Same — tests the dead `lib/counter/view/counter_page.dart`. |
| (everything real) | **Zero tests** for home, services, projects, contact form, or routing. |

Why nobody notices: **CI never runs `flutter test`.** The workflow
(`.github/workflows/main.yaml`) runs `pub get` → `gen-l10n` → `flutter analyze
--no-fatal-warnings --no-fatal-infos` → `flutter build web` → deploy. No test
step.

Two cosmetic lies that follow from this:

- `coverage_badge.svg` reads **100%** — stale/meaningless (nothing generates it).
- README shows an **MIT license badge** (`README.md:5`, `:160-161`) but there is
  **no `LICENSE` file** in the repo.

### Run the (currently broken) suite once to see the failures

The test helper `test/helpers/pump_app.dart` imports `AppLocalizations`, so the
generated l10n must exist first. Use the wrapper script or:

```sh
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter test            # counter + app tests FAIL today — expected
```

(`fvm` and the pinned SDK are owned by `ato-website-build-deploy`.)

---

## Part 2 — Add real tests (the forward-looking core)

**Maintainer requirement (A2):** widget/integration tests **MUST cover
responsive/mobile-view/small-screen layouts.** Widget tests satisfy this — they
run headless and let you set the surface size. You do not need a browser for
responsive coverage.

### The one thing you must understand before writing a responsive test

This app decides layout from **mutable static globals**, not from `MediaQuery`
at the point of use:

- Breakpoints live in `lib/utils/screen_utils.dart:26-29`:
  `< 600 → compact`, `< 840 → medium`, else `expanded`.
- Those feed three globals in `lib/utils/constants.dart:5-7`:
  `Constants.isCompactScreen` / `isMediumScreen` / `isExpandedScreen`
  (default: compact `true`, others `false`).
- The globals are **only recomputed inside `App.build`**
  (`lib/app/view/app.dart:103-108`, which reads `MediaQuery`).
- Feature widgets read the globals **directly** — e.g.
  `home_screen_content.dart:29,42`, `home_screen.dart:120`,
  `contact_us_screen.dart:73,131` all branch on `Constants.isExpandedScreen`.
  (Architecture rationale: `ato-website-architecture`.)

**Consequence for tests:** setting the surface size alone does **not** update
the globals unless `App.build` runs. A widget-level test that pumps one page in
isolation MUST set the globals explicitly, or it will silently test the default
(compact) layout no matter what width you gave it.

The helper below does both — set surface size AND recompute the globals from the
same breakpoints — so your tests can't drift out of sync.

### Copy this helper into `test/helpers/responsive_pump.dart`

The full, ready-to-paste helper and two worked test skeletons (a phone width
`< 600` and a desktop width, asserting compact-vs-expanded layout on a real
page) are in **`references/testing-guide.md`**. The core idea:

```dart
Future<void> pumpAtWidth(
  WidgetTester tester,
  Widget child, {
  required double width,
  double height = 900,
}) async {
  // 1. Set the real surface size (for widgets that DO read MediaQuery).
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  // 2. Recompute the static globals from the SAME breakpoints the app uses
  //    (screen_utils.dart) — feature widgets read these, not MediaQuery.
  Constants.isCompactScreen = width < 600;
  Constants.isMediumScreen = width >= 600 && width < 840;
  Constants.isExpandedScreen = width >= 840;

  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pump();
}
```

Then assert the responsive difference. A robust, high-value assertion for
mobile coverage is **"no overflow at phone width"** — a `RenderFlex` overflow
surfaces as an exception you can catch:

```dart
testWidgets('home lays out without overflow at phone width', (tester) async {
  await pumpAtWidth(
    tester,
    BlocProvider(create: (_) => ServiceSelectCubit(), child: HomeScreenContent()),
    width: 375,
  );
  expect(tester.takeException(), isNull); // catches RenderFlex overflow
});
```

Notes that matter (details + full desktop-vs-phone example in the guide):

- `HomeScreenContent` needs a `ServiceSelectCubit` provider (it uses
  `BlocBuilder<ServiceSelectCubit, int>`, `home_screen_content.dart:111,120`).
- Prefer **widget-level** pumping (plain `MaterialApp`) over pumping the whole
  `App()`. `App` installs a `GoogleFonts.notoSansTextTheme()` theme
  (`app.dart:119`) which tries a runtime font fetch under test; a plain
  `MaterialApp` sidesteps it. If you must pump `App()`, set
  `GoogleFonts.config.allowRuntimeFetching = false` first.
- `integration_test` is **not** a dependency yet (`pubspec.yaml` dev deps:
  `bloc_test`, `mocktail`, `very_good_analysis`, `flutter_test` only). Adding
  browser-driven end-to-end tests requires adding it — see the guide.

### Replace the broken counter tests

Delete `test/counter/` and `test/app/view/app_test.dart` (or rewrite the app
test to assert `find.byType(HomeScreen)` instead of `CounterPage`). Keep
`test/helpers/pump_app.dart` — it is reusable. This is coupled to removing
`lib/counter/*` in the cleanup backlog below; do both together.

### Wire `flutter test` into CI — ONLY once real tests exist

Do **not** add the step while the suite is still the broken counter scaffold —
it will fail every build. Once real tests are green, add a step to
`.github/workflows/main.yaml` **after "Analyze" and before "Build web"**:

```yaml
      - name: Test
        run: flutter test --coverage
```

Exact placement and rationale (the analyze gate, why after analyze) are in
`references/testing-guide.md`. CI mechanics beyond this one step belong to
`ato-website-build-deploy`.

---

## Part 3 — Sanctioned cleanup backlog (A2: web-only for good)

**Decide-then-do, not silent deletion.** Each item is real debt the maintainer
has greenlit removing, but confirm the current state (evidence commands in
`references/cleanup-backlog.md`) before you delete, and land each as its own
reviewable change. Run `scripts/audit-cleanup.sh` for a read-only status pass.

| # | Item | Action | Evidence (verified 2026-07-07) |
| --- | --- | --- | --- |
| 1 | `lib/counter/*` dead scaffold + its tests | Delete `lib/counter/`, `test/counter/`, fix/remove `test/app/view/app_test.dart` | No refs in `lib/` outside `lib/counter/` (l10n `counterAppBarTitle` string is unrelated) |
| 2 | Empty Spanish l10n | Delete `app_es.arb` + regen, **or** actually translate | `lib/l10n/arb/app_es.arb` has only `counterAppBarTitle`; all UI copy is hardcoded English |
| 3 | Vestigial `android/`, `ios/`, `windows/` scaffolds | Trim to web-only | `firebase_options.dart` is web-only (android/iOS/macOS/windows/linux all `throw UnsupportedError`, `:24-49`); only Hosting deploys; README "works on iOS, Android, Web, and Windows" (`README.md:34`) is CLI boilerplate |
| 4 | 5 stale Dependabot branches + `origin/versions/2` | Prune remote branches; bump `go_router` off `^6.5.2` deliberately | `git branch -r`: `dependabot/pub/{bloc_test-9.1.3, flutter_bloc-8.1.3, go_router-10.0.0, url_launcher-6.1.11, very_good_analysis-4.0.01}` + `versions/2`; `pubspec.yaml:22` pins `go_router: ^6.5.2` |
| 5 | Orphaned assets | Delete `assets/under-construction*.png` | Referenced only in a commented-out attribution (`app.dart:129-130`); no code use |
| 6 | Committed hosting cache | `git rm --cached` + gitignore | `.firebase/hosting.YnVpbGQvd2Vi.cache` is tracked |
| 7 | Unused imports (the analyze debt) | Remove them | `intl` unused in `constants.dart:1`; `dart:math as math` and `url_launcher_string` unused in both `services_screen.dart` and `projects_screen.dart` (`:7,:10`) |
| 8 | Missing LICENSE vs MIT badge | Add a real `LICENSE` **or** drop the badge | README claims MIT (`:5,:160-161`); no `LICENSE` file |

Item 4's branches are on the **remote** — pruning needs `git push origin
--delete <branch>` and is a mutating action; get maintainer sign-off. Item 3 is
the largest blast radius (whole directories) — do it last and confirm nothing in
CI or `pubspec.yaml` assets references those trees.

Full per-item runbook, exact commands, and the "why this is safe" reasoning:
**`references/cleanup-backlog.md`**.

---

## Provenance and maintenance

Authored **2026-07-07** from direct inspection of
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`
(no CLAUDE.md/MEMORY.md in this repo — these skills are the persistent
knowledge). Cross-repo functions live at a separate path
(`../anaheim_technologies_website_functions`) and are not loadable from here.

Re-verify volatile facts (run from repo root):

```sh
# Test tree + broken counter assertion still present?
find test -type f
grep -n "find.byType(CounterPage)" test/app/view/app_test.dart

# Dead counter scaffold still referenced nowhere real?
grep -rn "CounterPage\|CounterCubit" lib/main_*.dart lib/bootstrap.dart lib/app/

# CI still has no test step? (expect: build/analyze/deploy, no "flutter test")
grep -n "flutter test" .github/workflows/main.yaml || echo "no test step (as documented)"

# Breakpoints + globals unchanged?
grep -n "deviceWidth <" lib/utils/screen_utils.dart
grep -n "isExpandedScreen\|isMediumScreen\|isCompactScreen" lib/utils/constants.dart

# Cleanup backlog still open?
bash .claude/skills/ato-website-testing-and-cleanup/scripts/audit-cleanup.sh
```

Open items stay **open** until the maintainer lands them. Nothing here is
oversold: the responsive test approach is verified against real widget code, but
the exact CI test step and any `integration_test` browser command must be
proven green in CI before you rely on them (labeled in the guide).
