# Brand & splash — deep reference

Verified 2026-07-07 against the website repo.

## Color tokens (`lib/utils/color_utils.dart`)

```dart
class AppColors {
  static const foregroundColor = Color(0xFFD3D3D3); // body text / icon tint
  static const whiteColor = Colors.white;           // wordmark, emphasis
  static const gradientTop = Color(0xFF1B282F);     // bg gradient top
  static const gradientBottom = Color(0xFF0D161A);  // bg gradient bottom + on-green text
  static const textLinkColor = Color(0xFF41F39E);   // SIGNATURE GREEN — links, buttons, accents
}
```

The dark background gradient (`gradientTop` → `gradientBottom`) is applied by
`WidgetUtils.defaultBackground` (`lib/utils/widget_utils.dart`) and used by
`HomeScreen` as the page chrome. `textLinkColor` is the one brand accent you
will reach for constantly — filled buttons, outlined-button borders/foreground,
hover underlines, the green SVG tint on `/projects`.

There is **no** dedicated "brand palette" object beyond this class, and no
semantic naming beyond these five. Contrast/accessibility of `#41F39E` on the
dark gradient has not been formally audited (note for a future design pass).

## Fonts

Three families in play:

1. **Noto Sans** — the base text theme, fetched at runtime by the `google_fonts`
   package: `GoogleFonts.notoSansTextTheme()` in `lib/app/view/app.dart:119`,
   re-colored to `AppColors.foregroundColor`. By default `google_fonts`
   downloads the font from Google's CDN on first paint and caches it, so the
   base font is a soft **network dependency** (it will fall back to a system
   sans if offline). This is stock Very Good CLI behaviour, not a deliberate
   choice; if bundling is ever wanted, `google_fonts` supports shipping the OTF
   as an asset instead.
2. **Mechsuit** (`fonts/Mechsuit.otf`, ~19 KB) — the "ATO" wordmark and section
   headers.
3. **Plavsky** (`fonts/Plavsky.otf`, ~34 KB) — taglines and accent text.

Both OTFs are declared in `pubspec.yaml:42-48`:

```yaml
fonts:
  - family: Plavsky
    fonts:
      - asset: fonts/Plavsky.otf
  - family: Mechsuit
    fonts:
      - asset: fonts/Mechsuit.otf
```

Applied via literal `fontFamily: 'Mechsuit'` / `'Plavsky'` strings (no central
constants). As of 2026-07-07, `Mechsuit` appears in 5 widget files and
`Plavsky` in 4 (incl. the `HoveredText` default style,
`widget_utils.dart:96`). Confirm before a rename: `grep -rn "fontFamily: '" lib/`.

### Why the splash references `assets/fonts/` when there is no such source dir

Source layout has the OTFs at repo-root `fonts/`, and there is **no**
`assets/fonts/` directory in the repo. Yet the splash `@font-face` loads
`assets/fonts/Mechsuit.otf`. This is correct, because:

- A pubspec `asset: fonts/Mechsuit.otf` becomes the **bundle asset path**
  `fonts/Mechsuit.otf` (verified in a local build's
  `build/flutter_assets/FontManifest.json`: family `Mechsuit` → `fonts/Mechsuit.otf`).
- Flutter's **web** build serves every bundled asset under the `assets/`
  prefix, so at runtime the file is reachable at `assets/fonts/Mechsuit.otf`.

So the raw HTML splash and the Flutter app end up loading the *same* physical
OTF from the same served URL. **Do not "fix" the splash path to `fonts/…`** — it
would 404 on the deployed site.

## Splash screen anatomy (`web/index.html:50-119`)

Added in website-repo commit `95e1d9d` ("add branded splash screen for
cold-start gap"). Purpose: mask the ~1–3 s white gap before Flutter's first
frame on a cold load.

Structure:

- `<style>` block (`:50-102`): two `@font-face` rules (`:51-60`), then the
  `#ato-splash` overlay and its children.
  - `#ato-splash` — `position: fixed; inset: 0; z-index: 9999;` on `#0A0A0A`,
    centered column (`:61-73`).
  - `.ato-fade-out` — `opacity: 0` transition class toggled on dismiss (`:74-77`).
  - `.ato-mark` — "ATO" in Mechsuit, 56 px, white, letter-spaced (`:78-83`).
  - `.ato-pulse` — a 60×2 px bar in **`#3EE58C`** with the `ato-pulse` keyframe
    scaleX animation (`:84-90`, keyframes `:98-101`).
  - `.ato-tagline` — "Ideas — Delivered" in Plavsky, uppercase, **`#3EE58C`**
    (`:91-97`).
- `<body>` markup (`:106-110`): the `#ato-splash` div with the three children.
- Dismiss script (`:111-119`): on the `flutter-first-frame` window event, add
  `ato-fade-out`, then `splash.remove()` after 400 ms (matching the 0.4 s CSS
  transition).

### The green mismatch (known nit)

Splash accent `#3EE58C` (`:87`, `:95`) ≠ app signature green `#41F39E`
(`color_utils.dart:8`). The two are maintained independently — the splash is raw
HTML, the app reads Dart constants — so they drifted. If you unify them, change
the splash hex to `#41F39E` in **both** `web/index.html:87` and `:95`. Leave it
labeled as a nit otherwise; it is cosmetic and low priority.

### Editing rules

- Editing the splash is a plain HTML/CSS edit in `web/index.html`; no Dart.
- **Keep the `flutter-first-frame` listener** (`:112`). If you remove or break
  it, the overlay never dismisses and the site appears stuck on the splash.
- If you add a new font to the splash, add a matching `@font-face` and rely on
  the same `assets/fonts/<File>.otf` served path (see above).
