---
name: ato-website-architecture
description: Use when navigating or modifying lib/ in the Anaheim Technologies website, adding or wiring a route/page, working with the GoRouter ShellRoute + HomeScreen chrome, adding a bloc/cubit or reading state flow, touching the responsive Constants.is*Screen static-globals pattern, editing MasterDetailScreen / shared widget_utils backgrounds, dealing with web-only Firebase init, or tracing the contact-form Firestore write on the website side.
---

# Anaheim Technologies website — architecture

How the Flutter web app is assembled: entrypoints, routing, state, responsive layout,
shared widgets, Firebase init, and the contact-form data flow. Repo root (all paths below
are relative to it):
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`.

Web-only Flutter app (Very Good CLI scaffold) → Firebase Hosting, single project
`anaheim-technologies`. Firestore is the only backend in this repo; the email side lives in
a **separate repo** (see the contact-form section).

## When NOT to use this skill (use the sibling instead)

| You are doing… | Use skill |
|---|---|
| Toolchain (fvm 3.41.6), build/run commands, CI/CD, how changes ship | `ato-website-build-deploy` |
| Marketing copy, brand system (fonts/colors), splash, adding a case study, l10n reality | `ato-website-content-and-brand` |
| Writing widget/integration tests (must cover small-screen layouts), CI test step, deleting dead scaffold | `ato-website-testing-and-cleanup` |
| The cross-repo inquiries pipeline, Firestore rules posture + rules-export runbook, the dev_ prefix email gap | `ato-website-inquiries-and-integration` |

This skill covers *how the code is wired*. Build/ship, look/copy, tests, and the
cross-repo/security posture are owned elsewhere.

## Entry & bootstrap

Three near-identical `lib/main_*.dart` entrypoints (`_development`, `_staging`, `_production`).
On web they differ only in log level: `main_development` = `Level.ALL`,
`main_production` = `Level.WARNING`. Each `main()` does, in order:
`WidgetsFlutterBinding.ensureInitialized()` → `Firebase.initializeApp(...)` →
`usePathUrlStrategy()` (behind `kIsWeb`; clean URLs, no `#`) → `bootstrap(() => App())`.

`lib/bootstrap.dart` installs the global `Bloc.observer = AppBlocObserver()` (logs every
bloc `onChange`/`onError`), wires `FlutterError.onError`, and runs the app inside
`runZonedGuarded`. **Any new app-wide error/observer wiring goes in `bootstrap.dart`, not in
`main_*.dart`.**

`lib/app/app.dart` is a one-line barrel: `export 'view/app.dart';`. The real `App` widget is
`lib/app/view/app.dart`.

## Routing — one GoRouter, one ShellRoute

`lib/app/view/app.dart` defines a single `GoRouter` (`_rootRouter`) with `initialLocation: '/'`
and exactly **one `ShellRoute`**. The shell's `builder` wraps every child page in
`HomeScreen(child: child)` — that is the persistent chrome (top menu + footer). Pages render
into `HomeScreen`'s `Expanded` slot; the footer (ATO wordmark + social icons) shows on every
route **except** `/` (guarded by `GoRouter.of(context).location != '/'`).

Routes (source order in `app.dart:30-92`; order does not affect matching):

| Path | Screen widget | File |
|---|---|---|
| `/` | `HomeScreenContent` | `lib/features/home/screen/home_screen_content.dart` |
| `/privacy` | `PrivacyScreen` | `lib/features/privacy/screen/privacy_screen.dart` |
| `/us` | `AboutUsScreen` | `lib/features/about_us/screen/about_us_screen.dart` |
| `/contact` | `ContactUsScreen` | `lib/features/contact_us/screen/contact_us_screen.dart` |
| `/projects` | `ProjectsScreen` | `lib/features/projects/screen/projects_screen.dart` |
| `/services` | `ServicesScreen` | `lib/features/services/screen/services_screen.dart` |

- **Transitions:** every route builds its page via `buildPageWithDefaultTransition<void>(...)`
  from `lib/utils/router_utils.dart` — a `CustomTransitionPage` with a 100 ms fade in/out.
  Reuse this helper for new routes; do not hand-roll a `CustomTransitionPage`.
- **Quirk:** the `/privacy` route declares **both** a `builder` and a `pageBuilder`. go_router
  uses `pageBuilder` when present, so the `builder` is dead. New routes should declare
  `pageBuilder` only.
- **Navigation is imperative:** widgets call `GoRouter.of(context).go('/path')` (see
  `home_screen.dart`, `widget_utils.dart`, `contact_us_screen.dart`). There is no typed route
  or `context.goNamed`.
- **Version pin (as of 2026-07-07):** `go_router` is locked to **6.5.2**
  (`pubspec.yaml` pins `^6.5.2`). `GoRouter.of(context).location` used in
  `home_screen.dart:58` is the **go_router 6 API**; it was removed in later majors (replaced by
  `GoRouterState.of(context).uri`). A go_router bump must migrate that call. An abandoned
  Dependabot branch proposes go_router 10 — treat the bump as a real migration, not a patch.

Full route-add checklist + the ShellRoute wiring diagram: `references/routing-and-responsive.md`.

## State management — bloc/cubit

`flutter_bloc` **8.1.1** / `bloc` **8.1.0** (as of 2026-07-07). Inventory:

| Class | Type | Provided at | Purpose |
|---|---|---|---|
| `ContactUsBloc` | `Bloc` (event/state) | `App.build` (`app.dart:110`), above the router → app-wide | Writes the contact form to Firestore (the only backend call) |
| `ServiceSelectCubit` | `Cubit<int>` | `HomeScreen` via `MultiBlocProvider` (`home_screen.dart:27`) | Which of 3 home services is expanded (0/1/2) |
| `MenuSelectionCubit` | `Cubit<int>` | `HomeScreen` via `MultiBlocProvider` (`home_screen.dart:30`) | Which nav item shows the "selected" indicator (0=none,1=about,…4=contact) |

- The two cubits are `Cubit<int>` with named mutators (`selectBranding()`, `selectAbout()`, …)
  and boolean getters — trivial UI selection state, no models.
- **Scoping matters:** `ContactUsBloc` sits *above* the `GoRouter`, so it survives route changes
  and is reachable from `/contact` via `BlocProvider.of<ContactUsBloc>(context)`. The two cubits
  are provided *inside* `HomeScreen` (the shell), so they persist across route changes too but
  are scoped to the shell subtree, and are what `home_screen_content.dart` reads.
- **Naming trap:** `ContactUsBloc.sendEmail(...)` sends **no email** — it validates non-empty
  fields then adds a Firestore document. Email is sent by the separate functions repo reacting
  to that write (see below).

Full bloc/cubit event/state shapes and the contact write field-by-field:
`references/state-and-data-flow.md`.

## Responsive — mutable static globals (load-bearing smell)

`lib/utils/screen_utils.dart` classifies width into a `ScreenSize` enum via `getScreenSize(context)`:

| Width (MediaQuery) | `ScreenSize` |
|---|---|
| `< 600` | `compact` (phone) |
| `< 840` | `medium` (tablet) |
| `>= 840` | `expanded` (desktop) |

Instead of reading that at each use site, `App.build` (`app.dart:103-108`) writes the result into
**three mutable static booleans** on `lib/utils/constants.dart`:
`Constants.isExpandedScreen`, `Constants.isMediumScreen`, `Constants.isCompactScreen`. Widgets
then branch on those globals directly (e.g. `home_screen.dart:120 _buildMenu`,
`services_screen.dart:47`, `contact_us_screen.dart:73`, `widget_utils.dart:152`).

**Why it is load-bearing, not just dead smell:** `App.build` calls `getScreenSize(context)`,
which reads `MediaQuery.of(context)`. That subscribes `App` to size changes, so a browser resize
rebuilds `App`, which **recomputes the globals before the rest of the tree rebuilds**. Break that
(e.g. stop reading MediaQuery in `App.build`) and the globals go stale on resize.

**Rules of the road:**
- Do NOT read `Constants.is*Screen` inside code that runs *before* `App.build` (they default to
  `isCompactScreen = true`, the others `false`).
- For **new** code, prefer reading layout at the point of use — `LayoutBuilder`, or
  `getScreenSize(context: context)` directly (it is context-based and needs no globals) — rather
  than adding more reads of the static globals. This keeps widgets testable in isolation.
- Tests **must** exercise compact/medium widths, not just desktop. Because layout hinges on these
  globals + `MediaQuery`, a widget test must pump at a small size to hit the mobile branches. See
  `ato-website-testing-and-cleanup`.

## Shared widgets

`lib/utils/widget_utils.dart`:
- `WidgetUtils.defaultBackground({context, child})` — black `ColoredBox` + `GradientUtils.singleGradient`, `SizedBox.expand`. The standard full-bleed screen background; `HomeScreen` wraps the whole app in it.
- `WidgetUtils.extendedBackground({context, height, width?, child})` — scrollable, two-pass `GradientUtils.extendedGradient`.
- `WidgetUtils.showDetailNarrative({context, detailText})` — a `Text.rich` narrative with a "Talk to us today!" link that `go`s to `/contact`.
- `HoveredText` — the stateful nav/label widget (underline-on-hover or filled indicator, Plavsky font by default). Drives desktop menu items and `MasterDetailScreen` titles; supports `navigateTo` (calls `GoRouter.go`) and/or `onTap`.

`GradientUtils` (`lib/utils/gradient_utils.dart`) holds the two `LinearGradient`s used above
(colors from `AppColors`; the palette is owned by `ato-website-content-and-brand`).

**`MasterDetailScreen` — correction to fix in your mental model:** it is **NOT** in
`widget_utils.dart`. It is defined in
`lib/features/projects/screen/projects_content_screen.dart:11`
(the file misleadingly named for projects). It is the shared master/detail layout used by **both**
`ProjectsScreen` (`projects_screen.dart:19`) and `ServicesScreen`
(`services_screen.dart:48,69`): a title list where tapping an item reveals a narrative + optional
detail widget. Reuse it for any future "list of things, tap to expand" page rather than rebuilding it.

## Firebase init — web only

`lib/firebase_options.dart` is FlutterFire-generated but configured for **web only**:
`DefaultFirebaseOptions.currentPlatform` returns `web` under `kIsWeb` and **throws
`UnsupportedError` for android/iOS/macOS/windows/linux**. The `android/`, `ios/`, `windows/`
scaffolds are vestigial (web-only is the product decision — see `ato-website-content-and-brand`
and the cleanup backlog in `ato-website-testing-and-cleanup`). Do not assume you can `flutter run`
this on a device; Firebase init will throw.

`lib/utils/platform_stub.dart` provides a no-op `usePathUrlStrategy()` for non-web via the
conditional import in `main_*.dart` (`if (dart.library.html)` swaps in the real
`flutter_web_plugins` one). On web, the real clean-URL strategy is used.

## Contact-form data flow (website side)

`ContactUsScreen` (`contact_us_screen.dart`) collects Full name / Email / Message via three
`TextEditingController`s and calls `contactUsBloc.sendEmail(...)`. That dispatches `SendEmailEvent`;
`ContactUsBloc._handleSendEmailEvent` (`contact_us_bloc.dart:36`) writes **one Firestore document**:

```dart
FirebaseFirestore.instance
    .collection('${_firestore_collection_prefix}inquiries')
    .add({
  'email_address': event.email,
  'full_name': event.fullName,
  'message': event.message,
  'inquired_on': DateTime.now().millisecondsSinceEpoch,
});
```

State progression on the screen: `ContactUsErrorState` → SnackBar; `ContactUsSuccessState` →
"We received your message!" dialog (see the `BlocListener` in `contact_us_screen.dart:22`).

The written collection is `${_firestore_collection_prefix}inquiries` (`contact_us_bloc.dart:26`).
**Where this skill stops:** the prefix/`ENVIRONMENT` reality (why prod writes plain `inquiries`),
the by-design `dev_inquiries` email gap, the separate functions-repo trigger that turns the write
into email, and the Firestore rules posture are all owned by
`ato-website-inquiries-and-integration` — go there, not here. This skill covers only the website
side up to the `.add()` write.

## Adding a new page (quick runbook)

1. Create `lib/features/<name>/screen/<name>_screen.dart` (a `StatelessWidget`/`StatefulWidget`);
   wrap content in a `SingleChildScrollView` — it renders inside `HomeScreen`'s `Expanded` slot,
   which already supplies the gradient background and the menu/footer chrome.
2. Add a `GoRoute` inside the single `ShellRoute` in `lib/app/view/app.dart`, using
   `buildPageWithDefaultTransition<void>` in its `pageBuilder`.
3. For a nav entry: add a case in `HomeScreen._buildMenu` (both the compact `PopupMenuButton`
   branch and the expanded `HoveredText` row) and a `MenuSelectionCubit.select…()` mutator.
4. Branch responsive layout via `getScreenSize(context)` / `Constants.is*Screen`; verify at
   `<600` width.
5. Reuse `MasterDetailScreen` for tap-to-expand list pages, and `WidgetUtils.showDetailNarrative`
   for narrative bodies with a contact CTA.

## Provenance and maintenance

Authored 2026-07-07 from direct inspection of the repo (git history is shallow; no invented
history). Volatile facts are date-stamped inline. Re-verify with:

```bash
cd /Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website
# routes, shell, transition helper, responsive globals, prefix logic, Firebase web-only,
# MasterDetailScreen true home, and pinned versions — all in one pass:
.claude/skills/ato-website-architecture/scripts/verify-architecture.sh
```

If that script reports mismatches, fix the affected table/section here; the script only checks
that the anchors still exist, not their surrounding prose.
