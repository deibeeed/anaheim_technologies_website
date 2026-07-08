# CLAUDE.md

Guidance for Claude Code working in the **Anaheim Technologies marketing website** — a Flutter **web** app deployed to Firebase Hosting (`anaheimtechnologies.com`).

## Skill library (read first)

This repo has an on-demand skill library at `.claude/skills/`. Load the relevant one before non-trivial work — each SKILL.md holds the verified depth this file intentionally omits:

| Skill | Load when |
|---|---|
| `ato-website-build-deploy` | building, running, deploying, or touching CI |
| `ato-website-architecture` | navigating/modifying `lib/`, routing, state, responsive layout |
| `ato-website-content-and-brand` | editing copy, case studies, fonts, palette, the splash screen |
| `ato-website-testing-and-cleanup` | writing tests (must cover small-screen) or clearing the web-only debt |
| `ato-website-inquiries-and-integration` | the contact form → Firestore → email pipeline and its security |

## Always-true facts

- **`fvm flutter` only** — Flutter is pinned to 3.41.6 via `.fvmrc`; there is no system `flutter`/`dart` on PATH. (CI is the exception — it uses `subosito/flutter-action`.)
- **Web-only.** `firebase_options.dart` is web-only; the `android/`, `ios/`, `windows/` scaffolds are vestigial (nothing builds or ships them).
- **Push to `master` auto-deploys LIVE** to Firebase Hosting (project `anaheim-technologies`); a PR against `master` deploys an ephemeral preview channel. CI has **no test step** and the analyze gate is errors-only.
- **The contact form sends no email from this repo** — `ContactUsBloc` writes one Firestore doc to `${prefix}inquiries`; a Cloud Function in the **separate** repo `../anaheim_technologies_website_functions` sends the email. `ENVIRONMENT=development` → `dev_inquiries` (no email, by design); prod builds ship empty `ENVIRONMENT` → `inquiries` (the path the trigger watches).
- **Single Firebase project, prod-only** (`anaheim-technologies`). Emulators are the dev path.

## Quick commands

```bash
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter run -d chrome -t lib/main_development.dart --dart-define=ENVIRONMENT=development
fvm flutter build web --release -t lib/main_production.dart   # what CI ships
```
