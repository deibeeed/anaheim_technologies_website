# Routing + responsive — deep reference

Companion to `../SKILL.md`. Paths relative to repo root
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`.
Verified 2026-07-07.

## The ShellRoute wiring, concretely

`lib/app/view/app.dart` builds ONE router. Structure:

```
GoRouter(navigatorKey: rootNavigatorKey, initialLocation: '/')
└─ ShellRoute
   ├─ builder: (context, state, child) => HomeScreen(child: child)   // persistent chrome
   └─ routes: [ GoRoute('/'), GoRoute('/privacy'), GoRoute('/us'),
                GoRoute('/contact'), GoRoute('/projects'), GoRoute('/services') ]
```

- `HomeScreen` (`lib/features/home/screen/home_screen.dart`) is the chrome: it paints the
  full-bleed `WidgetUtils.defaultBackground`, a centered `SizedBox(width: 1000)` column with the
  top menu (`_buildMenu`), the routed `child` in an `Expanded`, and a footer.
- The footer (ATO wordmark + Facebook/LinkedIn SVGs) renders only when
  `GoRouter.of(context).location != '/'` — i.e. hidden on the landing page.
- `_buildMenu` has two layouts, chosen by `Constants.isExpandedScreen`:
  desktop → a `Row` of `HoveredText` items; compact/medium → a `PopupMenuButton` hamburger.
  Both mutate `MenuSelectionCubit` and call `GoRouter.of(context).go(...)`.
- `App.rootNavigatorKey` is a `static final GlobalKey<NavigatorState>` passed to the router.
  The `ShellRoute` itself has no separate navigator key (single-navigator shell).

## Page transition helper

`lib/utils/router_utils.dart` — every route must use this rather than a raw page:

```dart
buildPageWithDefaultTransition<void>(
  context: context, state: state, child: <YourScreen>(),
)
```

It returns a `CustomTransitionPage` keyed by `state.pageKey`, 100 ms fade in and out
(`FadeTransition(opacity: animation)`).

## go_router version reality (as of 2026-07-07)

- `pubspec.yaml` pins `go_router: ^6.5.2`; `pubspec.lock` resolves **6.5.2**.
- `home_screen.dart:58` uses `GoRouter.of(context).location`. This getter is **go_router 6 API**
  and was removed in later majors. If you bump go_router:
  - replace `.location` with `GoRouterState.of(context).uri.toString()` (or `.path`),
  - re-check `ShellRoute`/`GoRoute` signatures (they changed across 7→10),
  - test every `.go('/...')` call.
- An abandoned Dependabot branch proposes go_router 10.0.0. Treat any bump as a migration task,
  coordinated with the owner; it is not a drop-in patch.

## Responsive globals — full rationale and the safe migration path

Source of truth for breakpoints: `lib/utils/screen_utils.dart`.

```dart
ScreenSize getScreenSize({required BuildContext context}) {
  final w = MediaQuery.of(context).size.width;
  if (w < 600) return ScreenSize.compact;   // phone
  if (w < 840) return ScreenSize.medium;     // tablet
  return ScreenSize.expanded;                // desktop
}
```

`lib/utils/constants.dart` holds the mutable mirror:

```dart
class Constants {
  static bool isExpandedScreen = false;
  static bool isMediumScreen   = false;
  static bool isCompactScreen  = true;   // default before App.build runs
}
```

`App.build` (`app.dart:103-108`) recomputes all three from `getScreenSize(context)` on every
build. Because `getScreenSize` reads `MediaQuery.of(context)`, `App` is subscribed to size
changes, so a resize rebuilds `App` first and refreshes the globals before descendants rebuild.
That ordering is the entire reason the pattern is correct rather than merely lucky.

**Known hazards:**
- The globals are process-global mutable state. In a `flutter test`, they carry the value from
  whatever last ran unless you pump `App` (or set them) at your target size. Prefer pumping the
  real widget under `MediaQuery` with a chosen `Size` so `App.build` sets them for you.
- Reading them from code that executes before the first `App.build` yields the defaults
  (`isCompactScreen = true`).
- `constants.dart` imports `package:intl` but uses nothing from it (a stale unused import; the
  analyze gate was relaxed to tolerate such debt — see `ato-website-build-deploy`).

**Recommended for new code:** read layout locally instead of adding new global reads —
`LayoutBuilder`, `MediaQuery.sizeOf(context)`, or `getScreenSize(context: context)` at the use
site. This makes a widget self-contained and testable without booting `App`. Don't do a
big-bang rewrite of existing global reads unless the owner asks; just stop growing them.

## Consumers of `Constants.is*Screen` (as of 2026-07-07)

`grep -rn "Constants.is" lib/` — expect hits in `widget_utils.dart` (HoveredText corner radii),
`home_screen.dart` (`_buildMenu` desktop vs hamburger), `services_screen.dart` (two-column vs
stacked `MasterDetailScreen`), and `contact_us_screen.dart` (form width: full vs 350). Any new
responsive branch should be added deliberately and covered by a small-screen test.
