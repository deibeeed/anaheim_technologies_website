# Entrypoints & the `ENVIRONMENT` dart-define

Verified against the repo 2026-07-07. This is the detail behind the "three
`main_*.dart` entrypoints" and "`ENVIRONMENT` inconsistency" summaries in
SKILL.md.

## The three entrypoints

All three live in `lib/` and end by calling `bootstrap(() => App())` from
`lib/bootstrap.dart` (which installs a global `AppBlocObserver` and a
`runZonedGuarded` error handler). On **web** the behavioral differences are
minimal:

### `lib/main_development.dart`
```dart
Logger.root.level = Level.ALL;                       // verbose logs
// ... onRecord listener prints every record ...
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
if (kIsWeb) { usePathUrlStrategy(); }
const env = String.fromEnvironment('ENVIRONMENT');   // read + logged
bootstrap(() => App());
```

### `lib/main_production.dart`
Identical to development **except** `Logger.root.level = Level.WARNING`. This is
the entrypoint CI builds and deploys (`flutter build web --release -t
lib/main_production.dart`).

### `lib/main_staging.dart`
Materially different — a minimal stub:
```dart
void main() {
  if (kIsWeb) { usePathUrlStrategy(); }
  bootstrap(() => App());
}
```
- **No `Firebase.initializeApp`.** Any code path that touches Firestore (e.g. the
  contact form `.add()` in `contact_us_bloc.dart`) will fail at runtime because
  Firebase was never initialized.
- No logging configuration, no `ENVIRONMENT` read.
- Not used by CI, and not the IntelliJ/VSCode "production" path. **Avoid it** for
  anything that exercises the backend; use development or production.

### Net
`main_development` vs `main_production` differ only in log verbosity on web.
`main_staging` is a near-empty stub missing Firebase init. The `--flavor`
(development/staging/production) in the run configs is an Android/iOS build-flavor
concept and does not affect the web artifact; CI passes no `--flavor`.

## `ENVIRONMENT` — where it's read and what it changes

`String.fromEnvironment('ENVIRONMENT')` (a compile-time constant, injected via
`--dart-define`) appears in:

1. `main_development.dart` / `main_production.dart` — read into `env` and logged.
   Cosmetic only.
2. `lib/features/contact_us/bloc/contact_us_bloc.dart` —
   `_firestore_collection_prefix` returns `'dev_'` when `env == 'development'`,
   else `''`. This is the **only** place `ENVIRONMENT` changes behavior:

```dart
String get _firestore_collection_prefix {
  const env = String.fromEnvironment('ENVIRONMENT');
  if (env == 'development') { return 'dev_'; }
  return '';
}
// ... writes to collection('${_firestore_collection_prefix}inquiries')
```

So:
- `ENVIRONMENT=development` → writes to `dev_inquiries`.
- any other value **or empty** → writes to `inquiries`.

## Who passes the define (the inconsistency)

| Launch path | File | `--dart-define=ENVIRONMENT` |
|---|---|---|
| IntelliJ development | `.idea/runConfigurations/development.xml` | `=development` |
| IntelliJ production | `.idea/runConfigurations/production.xml` | `=production` (+ `--web-renderer html`) |
| IntelliJ staging | `.idea/runConfigurations/staging.xml` | none (+ `--web-renderer html`) |
| VSCode (all 3) | `.vscode/launch.json` | **none** (only `--flavor` + `--target`) |
| CI build | `.github/workflows/main.yaml` | **none** |

## Consequence for the deployed site (intended, benign)

The CI production build passes no `--dart-define`, so `ENVIRONMENT` is empty in
the shipped bundle. Empty `!= 'development'` → the prefix is `''` → the contact
form writes to `inquiries`, which is the collection the Cloud Functions
`inquiryCreated` trigger watches. That is the intended production wiring.

The corollary — a **development** build (with `ENVIRONMENT=development`) writes to
`dev_inquiries`, a collection no deployed trigger watches, so no email is sent —
is a by-design gap. Full treatment of that pipeline and gap is in the sibling
skill `ato-website-inquiries-and-integration` (not duplicated here).

## Re-verify

```bash
grep -n "String.fromEnvironment('ENVIRONMENT')" lib/main_development.dart lib/main_production.dart lib/features/contact_us/bloc/contact_us_bloc.dart
grep -rn "dart-define=ENVIRONMENT" .idea/runConfigurations .vscode .github
grep -n "Level.ALL\|Level.WARNING\|initializeApp" lib/main_development.dart lib/main_production.dart lib/main_staging.dart
```
