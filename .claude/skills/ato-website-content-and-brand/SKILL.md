---
name: ato-website-content-and-brand
description: >-
  Use when editing marketing copy, hero/service/teaser text, or case studies on
  the Anaheim Technologies website; adding a new page or nav link; changing the
  brand colors, fonts, wordmark, or the cold-start splash screen; questions
  about "why is the splash green different from the app green", the Mechsuit /
  Plavsky fonts, or where a piece of on-page text lives; or deciding what to do
  about the scaffolded-but-unused Spanish (es) localization.
---

# ATO Website — Content & Brand

The marketing site for **Anaheim Technologies (ATO)** — a self-described
"specialist product studio, small by design, senior by default." This skill is
the home for the site's *domain*: the marketing copy, the case studies, the
brand system (colors / fonts / splash), and the recipes for editing them. It is
about **what the site says and how it looks**, not how it is wired.

Repo root (all paths below are relative to it):
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`

## What the site is (positioning, verified 2026-07-07)

- **Three services**, presented two different ways (see the asymmetry note
  below): Branding · Product Design/Development/Prototyping · Virtual Teams.
- **"CURRENTLY BUILDING: Loooans"** teaser on the home page — a fintech product
  in closed beta, used as social proof ("we dogfood every stack we recommend").
- **Two case studies** on `/projects`: `BPV Loan Monitoring` and
  `[PROTOTYPE] HLP Systems`.
- **Primary CTA** everywhere: booking link `https://bit.ly/CallATO`
  (`lib/features/home/screen/home_screen_content.dart:179`). Socials:
  `fb.com/anaheim.technologies`, `linkedin.com/company/anaheim-technologies`.
- **Tagline / voice:** "Ideas — Delivered". Also in the `<title>` and Open
  Graph / Twitter meta in `web/index.html:22-47`.

## When NOT to use this skill (use a sibling in THIS repo instead)

| Your task | Go to |
|-----------|-------|
| How routing / `ShellRoot` / `MasterDetailScreen` / the responsive-globals pattern actually *work* | **ato-website-architecture** |
| Build/run commands, fvm, Firebase Hosting deploy, how a copy change ships live | **ato-website-build-deploy** |
| Removing the empty `es` l10n, dead counter scaffold, or adding real widget tests | **ato-website-testing-and-cleanup** |
| The contact form → Firestore `inquiries` → email pipeline | **ato-website-inquiries-and-integration** |

This skill tells you *what copy to change and where the brand tokens are*; it
points to **ato-website-architecture** for the widget mechanics behind each
recipe rather than re-explaining them.

## The content model — where copy lives

**All real copy is hardcoded English string literals inside widgets.** There is
no CMS and l10n is effectively unused (see "l10n reality" below). To change text
you edit the Dart widget, then rebuild (`fvm flutter build web ...`, see
ato-website-build-deploy). No `.arb` regeneration is involved.

| Page / route | File | What copy lives here |
|--------------|------|----------------------|
| `/` home | `lib/features/home/screen/home_screen_content.dart` | Hero sentence (`:22`), "Ideas -\nDelivered" tagline (`:34`,`:46`), the 3-way service blurb `switch` (`:130-137`), "Are you ready to co-create…" (`:154`), "CURRENTLY BUILDING / Loooans" teaser (`:207`,`:216`,`:226`), footer |
| `/services` | `lib/features/services/screen/services_screen.dart` | Four long narratives declared as locals (`brandingNarrative`, `pddNarrative`, `prototypingNarrative`, `virtualTeamsNarrative`, `:21-45`) + `titleList` (`:52-57`) |
| `/projects` | `lib/features/projects/screen/projects_screen.dart` | `titleList` (`:22-24`), `narrativeList` (`:26-40`), `detailList` images/SVG (`:42-77`) |
| `/us` about | `lib/features/about_us/screen/about_us_screen.dart` | Bio `Text.rich` (`:29-41`) + the 14-logo tech `Wrap` (`:68-82`) |
| `/contact` | `lib/features/contact_us/screen/contact_us_screen.dart` | Form labels/CTA copy (form *behaviour* → ato-website-inquiries-and-integration) |
| `/privacy` | `lib/features/privacy/screen/privacy_screen.dart` | Thin Data-Privacy-Act-of-2012 notice |
| Nav labels & footer | `lib/features/home/screen/home_screen.dart` | Menu items ("about us / services / projects / contact us"), footer ATO wordmark + social icons |
| Splash, SEO, OG/Twitter meta, page `<title>` | `web/index.html` | See brand section |

Full copy inventory with every string anchor: `references/content-map.md`.

> **Content asymmetry to know before touching services.** The home page service
> selector has **3** buttons (`Branding` / `Product Design, Development and
> Prototyping` / `Virtual Teams`, `home_screen_content.dart:292-373`) but the
> `/services` page splits them into **4** items (`Branding` / `Product design
> and development` / `Prototyping` / `Virtual teams`). Labels also differ in
> casing/wording between the two. If you rename a service, update **both** so
> the story stays consistent.

## Brand system

Colors live in one place: `lib/utils/color_utils.dart` (class `AppColors`).

| Token | Hex | Role |
|-------|-----|------|
| `gradientTop` | `#1B282F` | Page background gradient, top (`:6`) |
| `gradientBottom` | `#0D161A` | Page background gradient, bottom (`:7`); also used as on-green text color |
| `textLinkColor` | `#41F39E` | **Signature green** — buttons, links, accents, hover indicators (`:8`) |
| `foregroundColor` | `#D3D3D3` | Default body text / icon tint (`:4`) |
| `whiteColor` | `Colors.white` | Wordmark + emphasis (`:5`) |

**Fonts** (declared in `pubspec.yaml:42-48`):

| Family | Source | Used for |
|--------|--------|----------|
| **Noto Sans** | `google_fonts` at runtime (`app/view/app.dart:119`, `GoogleFonts.notoSansTextTheme()`) | Base body text theme |
| **Mechsuit** | bundled `fonts/Mechsuit.otf` | "ATO" wordmark + section headers ("Projects", "Services", "About us") |
| **Plavsky** | bundled `fonts/Plavsky.otf` | Taglines & accents ("Ideas - Delivered", "Loooans", nav labels; the `HoveredText` default, `widget_utils.dart:96`) |

Fonts are applied by literal `fontFamily: 'Mechsuit'` / `'Plavsky'` strings in
~17 spots — no central text-style constants. Grep before assuming a rename is
one edit: `grep -rn "fontFamily: '" lib/`.

**Two brand nits (labeled, do not "fix" silently):**

1. **Splash green ≠ app green.** The cold-start splash uses `#3EE58C`
   (`web/index.html:87`,`:95`) while the app's signature green is `#41F39E`
   (`color_utils.dart:8`). Known cosmetic inconsistency.
2. **Vestigial blue accent.** `MaterialApp`'s theme still carries the Very Good
   CLI default `Color(0xFF13B9FF)` for `appBarTheme` / `colorScheme.accentColor`
   (`app/view/app.dart:115-117`). The site renders no `AppBar`, so this blue is
   effectively dead; the real accent is `textLinkColor`.

Deeper brand reference (splash CSS anatomy, the font-path trick, google_fonts
runtime behaviour): `references/brand-and-splash.md`.

## The splash screen

Pure HTML/CSS injected into `web/index.html:50-119` (added in website-repo
commit `95e1d9d`, "add branded splash screen for cold-start gap"). It covers the
~1–3 s blank cold-start gap before Flutter paints its first frame.

- A fixed `#ato-splash` overlay on `#0A0A0A` shows "ATO" (Mechsuit, `:107`), an
  animated green pulse bar (`:108`), and "Ideas — Delivered" (Plavsky, `:109`).
- It **fades out and self-removes** when the browser fires the
  `flutter-first-frame` event (`:112-118`).
- Its `@font-face` rules load the bundled OTFs from `assets/fonts/Mechsuit.otf`
  / `assets/fonts/Plavsky.otf` (`:51-60`). **There is no `assets/fonts/`
  directory in source** — that path is where Flutter's web build serves any
  pubspec-declared asset. `asset: fonts/Mechsuit.otf` in `pubspec.yaml` becomes
  bundle path `fonts/Mechsuit.otf`, served on web under the `assets/` prefix →
  `assets/fonts/Mechsuit.otf`. Do not "correct" the splash path to `fonts/…`.

To edit the splash: change the markup/CSS directly in `web/index.html`. It is
plain HTML — no Dart, no rebuild-of-Flutter needed beyond the normal web build.

## Recipes

### Edit hero / service / teaser copy
1. Find the string in the table above (or `grep -rn "phrase" lib/`).
2. Edit the literal in place. Watch for `''' … '''` raw multiline strings
   (services narratives, projects narratives) and `switch` arms
   (`home_screen_content.dart:130-137`).
3. Rebuild & preview per **ato-website-build-deploy**.

### Add or edit a case study on `/projects`
Case studies are **three parallel index-aligned lists** on the shared
`MasterDetailScreen` (`projects_screen.dart`): `titleList[i]`,
`narrativeList[i]`, `detailList[i]` must all describe the same project at the
same index. To add one, append one entry to **each** of the three lists (a
title string, a narrative `'''…'''`, and a detail `Widget` — an `Image.asset`
or `SvgPicture.asset` from `assets/`). Add the image/SVG under `assets/images/`
or `assets/svg/` (already globbed by `pubspec.yaml:38-41`). For how
`MasterDetailScreen` renders and toggles these → **ato-website-architecture**.

### Add a new page / route
This skill owns the **content** half; the wiring half is
**ato-website-architecture**. Content steps:
1. Create the screen widget under `lib/features/<name>/screen/` with your copy.
2. Add its nav label in **both** menus in `home_screen.dart._buildMenu`: the
   expanded `HoveredText(text: …, navigateTo: '/<path>')` row and the compact
   `PopupMenuButton` `PopupMenuItem`.
3. Add a `MenuSelectionCubit` selector + `isXSelected` getter
   (`lib/features/home/cubit/menu_selection_cubit.dart`) so the nav highlight
   works, and call it from the menu `onTap`/`onSelected`.

For the `GoRoute`/`ShellRoute` registration and the `buildPageWithDefaultTransition`
wrapper → **ato-website-architecture**.

### Change or add a brand color / font
- **Color:** add/edit a `static const` in `AppColors`
  (`lib/utils/color_utils.dart`); reference it as `AppColors.<name>`. If it is
  used in the splash, mirror the hex into `web/index.html` by hand (the two are
  not linked — this is why the greens drifted).
- **Font:** drop the OTF in `fonts/`, declare it under `pubspec.yaml` `fonts:`,
  and (for the splash) add a matching `@font-face` in `web/index.html`. Apply
  with `fontFamily: '<Family>'`.

### Edit the splash
Edit `web/index.html:50-119` directly (markup + inline CSS). Keep the
`flutter-first-frame` listener intact or the splash never dismisses.

## l10n reality (scaffolded, effectively unused — removable debt)

`l10n.yaml` + `flutter_localizations` are wired (en + es, `generate: true`), and
generated `app_localizations*.dart` files are committed under `lib/l10n/arb/`.
**But the only translated key is `counterAppBarTitle`** (Very Good CLI
boilerplate) in both `app_en.arb` and `app_es.arb` — no real page copy is
localized, and nothing in the UI reads a localized string for content. The
Spanish (`es`) locale is untranslated in substance.

Per the maintainer (2026-07-07): the site is **web-only for good** and the empty
`es` l10n is **removable debt**. Treat it as safe-to-delete unless localization
is deliberately revived. The removal runbook (and the CI test-step decision)
lives in **ato-website-testing-and-cleanup** — do the actual deletion there, not
here.

## Provenance and maintenance

Authored 2026-07-07 from direct read-only inspection of the repo at
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`
(website repo, branch `master`). Binding maintainer decisions: web-only is
permanent; empty `es` l10n is removable debt (human-answers A2). The splash was
added in commit `95e1d9d` (website repo).

Re-verify volatile facts (run from repo root):

```bash
# Brand color tokens (expect #1B282F, #0D161A, #41F39E, #D3D3D3)
grep -n "Color(0xFF" lib/utils/color_utils.dart
# Splash green + the green mismatch (expect #3EE58C in index.html vs #41F39E above)
grep -n "3EE58C\|#0A0A0A\|flutter-first-frame" web/index.html
# Bundled fonts declared (expect Plavsky + Mechsuit from fonts/)
sed -n '42,48p' pubspec.yaml
# l10n is still boilerplate-only (expect just counterAppBarTitle)
cat lib/l10n/arb/app_en.arb
# One-shot check of all of the above:
bash .claude/skills/ato-website-content-and-brand/scripts/verify-brand.sh
```

If `color_utils.dart` gains new tokens, the splash hex changes, or `app_en.arb`
grows real keys, update this skill and `references/brand-and-splash.md`.
