# State + contact-form data flow — deep reference

Companion to `../SKILL.md`. Paths relative to repo root
`/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website`.
Verified 2026-07-07. `flutter_bloc` 8.1.1 / `bloc` 8.1.0, `cloud_firestore` 4.6.0,
`firebase_core` 2.11.0.

## Global bloc observer

`lib/bootstrap.dart` sets `Bloc.observer = AppBlocObserver()`. `AppBlocObserver` overrides
`onChange` and `onError` to `log(...)` (dart:developer). Every cubit/bloc transition and error is
logged app-wide. This is the one place bloc lifecycle is observed; add cross-cutting bloc logging
here, not per-bloc.

## The two selection cubits

Both are `Cubit<int>` holding a single index — no models, no async.

`lib/features/home/cubit/service_select_cubit.dart`:
```dart
class ServiceSelectCubit extends Cubit<int> {
  ServiceSelectCubit() : super(0);
  void selectBranding() => emit(0);
  void selectPdd()      => emit(1);
  void selectVt()       => emit(2);
}
```
Read by `home_screen_content.dart` (`BlocBuilder<ServiceSelectCubit,int>`) to pick which service
blurb is shown on `/`.

`lib/features/home/cubit/menu_selection_cubit.dart` — index 0..4 (0 = none, 1 = about,
2 = services, 3 = projects, 4 = contact) with `select…()` mutators and `is…Selected` getters.
Read by `HomeScreen._buildMenu` to highlight the active nav item.

Both are provided together in `HomeScreen` via `MultiBlocProvider` (`home_screen.dart:25`), so
they live for the lifetime of the shell and reset only on a full app restart.

## ContactUsBloc — the only backend call

Files: `lib/features/contact_us/bloc/contact_us_bloc.dart` (+ `contact_us_event.dart`,
`contact_us_state.dart` as `part` files).

Events:
- `SendEmailEvent({email, fullName, message})` — the only concrete event.

States (all extend `abstract ContactUsState`):
- `ContactUsInitial`
- `ContactUsLoadingState({isLoading = false, message})`
- `ContactUsSuccessState({message, data})`
- `ContactUsErrorState({required message, data})`

Public API used by the screen:
- `sendEmail({email, fullName, message})` — synchronous guard: if any field is empty it emits
  `ContactUsErrorState('Please fill up all fields')` and returns; otherwise it `add`s a
  `SendEmailEvent`. **Misnamed — it does not send email.**
- `isSendingEmail` getter — a plain `bool` field (`_isSendingEmail`) flipped inside the handler;
  the screen uses it to disable the form/button while a write is in flight. Note it is *not* part
  of the emitted state, so the UI relies on `BlocBuilder` rebuilds triggered by the loading-state
  emissions to re-read it.

Handler `_handleSendEmailEvent` (`contact_us_bloc.dart:36`):
1. set `_isSendingEmail = true`; `emit(ContactUsLoadingState(isLoading: true))`
2. `await FirebaseFirestore.instance.collection('${prefix}inquiries').add({...})`
3. on success: `_isSendingEmail = false`; `emit(ContactUsLoadingState())`; `emit(ContactUsSuccessState())`
4. on error: `emit(ContactUsLoadingState())`; `log.severe(...)`; `emit(ContactUsErrorState('Something went wrong while sending emails'))`

Document fields written to `inquiries` (exact keys — the functions repo consumes these):

| Firestore field | Source | Type |
|---|---|---|
| `email_address` | `event.email` | String |
| `full_name` | `event.fullName` | String |
| `message` | `event.message` | String |
| `inquired_on` | `DateTime.now().millisecondsSinceEpoch` | int (epoch ms) |

If you change a field name here, it is a coordinated cross-repo schema change — the functions
repo trigger reads these keys. Do not rename one side alone. (Pipeline + contract ownership:
`ato-website-inquiries-and-integration`.)

## Collection prefix logic

`_firestore_collection_prefix` (`contact_us_bloc.dart:26`):
```dart
const env = String.fromEnvironment('ENVIRONMENT');
if (env == 'development') return 'dev_';
return '';
```
`String.fromEnvironment` is compile-time (`--dart-define=ENVIRONMENT=...`). Result:
`development` → `dev_inquiries`; staging/production/empty → `inquiries`. The CI/deployed build
sets no `ENVIRONMENT` → writes `inquiries`. A dev build writing `dev_inquiries` triggers no email
because no function watches that collection (by-design; use emulators). Details:
`ato-website-inquiries-and-integration`.

Style nit: `_firestore_collection_prefix` is `snake_case` (Dart convention is `lowerCamelCase`);
tolerated because the analyze gate was relaxed (see `ato-website-build-deploy`).
