# Testing guide — worked skeletons and CI wiring

Depth for `SKILL.md` Part 2. Verified against the repo on 2026-07-07.
`fvm`/SDK setup is owned by `ato-website-build-deploy`; the responsive-globals
architecture is owned by `ato-website-architecture`. This file is the concrete
"how to write the test" runbook.

## 0. Prerequisites (once)

The reusable helper `test/helpers/pump_app.dart` imports
`AppLocalizations` (`lib/l10n/l10n.dart` → `lib/l10n/arb/app_localizations.dart`).
The generated l10n files are committed today, but CI regenerates them, so make it
a habit:

```sh
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter test
```

## 1. The responsive-globals trap (read this before writing any layout test)

The app does NOT read `MediaQuery` at the point of use. It reads three mutable
static booleans that are recomputed only in `App.build`:

- `lib/utils/screen_utils.dart:23-30` — `getScreenSize` maps width to
  `compact (<600) / medium (<840) / expanded`.
- `lib/app/view/app.dart:103-108` — `App.build` calls `getScreenSize(context)`
  (which reads `MediaQuery`) and writes `Constants.isExpandedScreen`,
  `isMediumScreen`, `isCompactScreen`.
- `lib/utils/constants.dart:5-7` — the globals. Defaults: `isCompactScreen =
  true`, the other two `false`.
- Feature widgets branch on the globals directly. Confirmed call sites:
  - `lib/features/home/screen/home_screen_content.dart:29` (`if (Constants.isExpandedScreen) ...[`)
  - `lib/features/home/screen/home_screen_content.dart:42` (`if (!Constants.isExpandedScreen)`)
  - `lib/features/home/screen/home_screen.dart:120`
  - `lib/features/contact_us/screen/contact_us_screen.dart:73,131`
    (`width: !Constants.isExpandedScreen ? double.infinity : 350`)

**Failure mode if you forget:** you set `tester.view.physicalSize` to a phone
width, but because the widget under test never calls `getScreenSize` and
`App.build` never ran, `Constants.isExpandedScreen` keeps its previous value.
Your "phone" test silently exercises whatever layout the globals happened to
hold. Worse, the globals are process-global and leak between tests. So: **set the
globals explicitly, and reset them.**

## 2. Full helper — `test/helpers/responsive_pump.dart`

```dart
import 'package:anaheim_technologies_website/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [child] at a given logical [width], setting BOTH the real surface
/// size (for any widget that reads MediaQuery) AND the mutable layout globals
/// in Constants (which most feature widgets read instead of MediaQuery).
///
/// Mirrors the breakpoints in lib/utils/screen_utils.dart (<600 / <840).
/// Tear-downs reset the view and the globals so tests don't leak into each
/// other.
Future<void> pumpAtWidth(
  WidgetTester tester,
  Widget child, {
  required double width,
  double height = 900,
}) async {
  tester.view.physicalSize = Size(width, height);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  Constants.isCompactScreen = width < 600;
  Constants.isMediumScreen = width >= 600 && width < 840;
  Constants.isExpandedScreen = width >= 840;
  addTearDown(() {
    // Restore the source defaults (constants.dart:5-7).
    Constants.isCompactScreen = true;
    Constants.isMediumScreen = false;
    Constants.isExpandedScreen = false;
  });

  await tester.pumpWidget(MaterialApp(home: child));
  await tester.pump();
}
```

## 3. Worked test — one page at phone AND desktop width

Target: `HomeScreenContent`. It renders the Plavsky "Ideas -\nDelivered"
tagline in **two different places** depending on width:

- Expanded (`>= 840`): inside the top `Row`, in the same line as the hero copy
  (`home_screen_content.dart:29-39`).
- Compact/medium (`< 840`): in its own full-width `SizedBox` below the row
  (`home_screen_content.dart:42-51`).

Both branches render exactly one such `Text`, so the tagline is present either
way — that makes a good smoke assertion — while the **no-overflow** check is the
real mobile-layout guard.

`HomeScreenContent` reads `BlocBuilder<ServiceSelectCubit, int>`
(`:111,:120`), so it must be wrapped in a `ServiceSelectCubit` provider.

```dart
import 'package:anaheim_technologies_website/features/home/cubit/service_select_cubit.dart';
import 'package:anaheim_technologies_website/features/home/screen/home_screen_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/responsive_pump.dart';

void main() {
  Widget subject() => BlocProvider(
        create: (_) => ServiceSelectCubit(),
        child: HomeScreenContent(),
      );

  group('HomeScreenContent responsive layout', () {
    testWidgets('phone width (<600): renders, no overflow', (tester) async {
      await pumpAtWidth(tester, subject(), width: 375);

      expect(tester.takeException(), isNull); // no RenderFlex overflow
      expect(find.textContaining('Ideas'), findsWidgets);
    });

    testWidgets('desktop width (>=840): renders, no overflow', (tester) async {
      await pumpAtWidth(tester, subject(), width: 1440);

      expect(tester.takeException(), isNull);
      expect(find.textContaining('Ideas'), findsWidgets);
    });
  });
}
```

### Asserting the actual layout difference (optional, more brittle)

If you want to prove the branch flipped (not just "renders"), assert on a
width-driven property. The contact page is the cleanest: the booking button's
`SizedBox` is `width: 350` when expanded and `double.infinity` when not
(`contact_us_screen.dart:73`). You can read it back:

```dart
// After pumpAtWidth(tester, ContactUsScreen(), width: 375):
// the first booking-button SizedBox should be full width, not 350.
```

Keep these targeted and few — asserting exact widths couples tests to layout
constants and breaks on cosmetic tweaks. The no-overflow + presence checks give
most of the mobile-coverage value at a fraction of the brittleness.

## 4. Gotchas that will waste your time

- **google_fonts runtime fetch.** Pumping the whole `App()` installs
  `GoogleFonts.notoSansTextTheme()` (`app.dart:119`), which attempts a network
  font fetch under test. Prefer widget-level pumping with a plain `MaterialApp`
  (as in the helper). If you genuinely need the full `App`, set
  `GoogleFonts.config.allowRuntimeFetching = false;` in `setUpAll`.
- **Firestore is only touched on submit.** `ContactUsBloc` writes to
  `FirebaseFirestore.instance` only inside `_handleSendEmailEvent`
  (`contact_us_bloc.dart:44-52`), not at construction. So you can pump
  `ContactUsScreen` and fill fields without a Firebase init; just don't drive
  the Send button in a plain widget test (that needs a fake Firestore — see
  below).
- **Static-global leakage.** Always reset the `Constants` globals (the helper
  does). A test that sets `isExpandedScreen = true` and forgets to reset will
  corrupt every later test in the file.
- **SVG assets.** `HomeScreenContent` loads `assets/svg/*.svg`
  (`:260,:275`). Assets declared in `pubspec.yaml` are available to widget
  tests via the bundle, but if a decode races the assertion, add
  `await tester.pumpAndSettle()`.

## 5. Testing the contact-form submit path (when you get there)

To test the submit → Firestore write without hitting real Firebase, inject a
fake. `ContactUsBloc` currently reaches `FirebaseFirestore.instance` directly
(`contact_us_bloc.dart:45`), so it is not injectable as written. Two options:

1. Add `fake_cloud_firestore` as a dev dependency and refactor `ContactUsBloc`
   to accept a `FirebaseFirestore` in its constructor (defaulting to
   `.instance`). Then `blocTest` the write. This is a small, worthwhile
   testability refactor.
2. Test only the pure validation branch, which needs no Firestore:
   `sendEmail` emits `ContactUsErrorState('Please fill up all fields')` when any
   field is empty (`contact_us_bloc.dart:71-74`) — a clean `blocTest` with no
   mocking.

Start with option 2 (free, real coverage of a real branch), do option 1 when
the refactor is welcome.

## 6. integration_test (browser end-to-end) — optional path

`integration_test` is **not** in `pubspec.yaml` today (dev deps are
`bloc_test ^9.1.0`, `mocktail ^0.3.0`, `very_good_analysis ^3.1.0`,
`flutter_test`). Widget tests already satisfy the responsive requirement
headlessly, so add integration tests only for true end-to-end flows (real
router navigation, real Firebase against an emulator).

To add it:

```yaml
# pubspec.yaml dev_dependencies:
  integration_test:
    sdk: flutter
```

Put tests in `integration_test/`. On web they run in a real browser via
chromedriver, not `flutter test`. The exact invocation
(`fvm flutter drive` / `fvm flutter test integration_test -d chrome` with a
running `chromedriver`) is **UNVERIFIED** here — prove it green locally and in
CI before documenting it as fact, and coordinate the CI runner setup with
`ato-website-build-deploy`.

## 7. CI test step — exact change

Add to `.github/workflows/main.yaml`, **after** the `Analyze` step and
**before** `Build web (production)` — fail fast on logic before spending build
time:

```yaml
      - name: Analyze (errors only)
        run: flutter analyze --no-fatal-warnings --no-fatal-infos

      - name: Test                       # <-- new
        run: flutter test --coverage

      - name: Build web (production)
        run: flutter build web --release -t lib/main_production.dart
```

Prerequisite: the suite must be green first (delete/rewrite the counter tests —
see the cleanup backlog). The CI runner already has the Flutter SDK from the
existing `subosito/flutter-action@v2` step, so no extra setup is needed. If you
later publish coverage, regenerate `coverage_badge.svg` from `coverage/lcov.info`
or delete the stale badge — do not leave the fake 100% badge in place.
