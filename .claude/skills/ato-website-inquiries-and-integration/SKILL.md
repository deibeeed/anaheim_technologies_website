---
name: ato-website-inquiries-and-integration
description: >-
  Use when working on the contact/inquiry form's Firestore write, the
  {prefix}inquiries collection or its dev_/prod ENVIRONMENT prefix, debugging why
  a contact-form submission did or did not send a notification email, the
  cross-repo handoff to the functions repo's inquiryCreated trigger, or the
  Firestore inquiries security rules (create-only posture, spam hardening,
  exporting console-managed rules into source).
---

# ATO website — inquiries pipeline & integration (website side)

This is the **primary home** for the contact-form → email pipeline **as seen from
this Flutter web repo**, plus the Firestore `inquiries` security posture and the
runbook to pull the console-managed rules into source.

The site's contact form does exactly ONE backend thing: it **writes a Firestore
document**. It sends no email itself. A **separate repo's** Firestore trigger
turns that write into email. Understand this boundary before touching anything.

## The pipeline (end to end)

```
[Browser: /contact form]                     (this repo)
  └─ ContactUsBloc.sendEmail() -> SendEmailEvent
       └─ FirebaseFirestore.instance
            .collection('${prefix}inquiries').add({...})   <- the ONLY backend call the site makes
            (prefix = 'dev_' iff --dart-define=ENVIRONMENT=development, else '')
            |
            v
[Firestore, project anaheim-technologies]
    collection "inquiries"       <- PROD path: a doc-create here fires the trigger
    collection "dev_inquiries"   <- DEV path: NO trigger watches this -> dead end (by design)
            |
            v  (server-side Firestore document-create event; browser is NOT involved)
[Functions repo: ../anaheim_technologies_website_functions]   (SEPARATE repo)
    inquiryCreated = onDocumentCreated('inquiries/{docId}')
       └─ POST -> sendMail (Microsoft Graph) -> confirmation + notification emails
```

Because the browser only ever talks to **Firestore** (never to the Cloud
Function), **CORS is a non-issue** on this path. The function is reached
server-to-server by Firestore's trigger, not by the web client.

The email/function half lives in a **different repo** and is documented there.
See "When NOT to use this skill" below. Do not try to load that repo's skills
from here — they are a different `.claude/skills` tree.

## The write contract (the website↔functions interface)

Source of truth: `lib/features/contact_us/bloc/contact_us_bloc.dart` (verified
2026-07-07). The `.add()` call at lines 45-52 writes these fields:

| Firestore field | Written from (this repo)                     | Type | Consumed by trigger? |
| --------------- | -------------------------------------------- | ---- | -------------------- |
| `email_address` | `event.email`                                | str  | yes -> `emailAddress` |
| `full_name`     | `event.fullName`                             | str  | yes -> `fullName`     |
| `message`       | `event.message`                              | str  | yes -> `messageRaw` / template |
| `inquired_on`   | `DateTime.now().millisecondsSinceEpoch`      | int  | **no** (written, ignored) |

The functions repo destructures `email_address`, `full_name`, `message` in
`functions/src/index.ts` (`inquiryCreated`). **These snake_case field names are a
contract.** If you rename a field here, the email breaks silently (the trigger
reads `undefined`), because the failure is server-side and the user already saw a
success state after the Firestore write. Change both repos together, and keep the
names snake_case.

`inquired_on` is a client-clock epoch-millis int, not a Firestore server
timestamp — fine for display/sort, but do not treat it as trustworthy time.

For **how the bloc and the form widget are wired into the app** (bloc states,
the `/contact` route, responsive layout), that is app architecture — see the
sibling skill `ato-website-architecture`, not here.

## Prefix / environment reality (why prod works, dev is a dead end)

The collection name is `'${_firestore_collection_prefix}inquiries'`. The prefix
getter (`contact_us_bloc.dart:26-34`):

```dart
String get _firestore_collection_prefix {
  const env = String.fromEnvironment('ENVIRONMENT');
  if (env == 'development') return 'dev_';
  return '';
}
```

- **Production** ships via CI: `.github/workflows/main.yaml` runs
  `flutter build web --release -t lib/main_production.dart` with **no**
  `--dart-define=ENVIRONMENT`. So `ENVIRONMENT` is empty -> prefix `''` ->
  writes plain **`inquiries`** -> the trigger fires -> email sends. This works.
- **Development** runs (e.g. the IntelliJ config, or a manual
  `fvm flutter run ... --dart-define=ENVIRONMENT=development`) write
  **`dev_inquiries`**.

**The dev gap is intentional (maintainer decision A4, 2026-07-07).** The
`inquiryCreated` trigger only watches `inquiries/{docId}`, and there is **no dev
Firebase project** (single project `anaheim-technologies`, `.firebaserc`). So a
development build's inquiries land in `dev_inquiries`, which **no trigger reads**,
so **no email is ever sent for dev-build submissions**. This is by design — the
sanctioned dev path for exercising the email flow is the **functions emulator**
(owned by the functions repo), not the live project. Do NOT "fix" this by
pointing dev at `inquiries` or by adding a `dev_inquiries` trigger; that would
send real email from local/test submissions. Leave it as-is.

For the single-project, prod-only environment model and how prod builds ship, the
primary home is the sibling skill `ato-website-build-deploy`.

## Security posture — OPEN, and thin (maintainer decision A3)

As of 2026-07-07, per the maintainer:

- The Firestore rules for `inquiries` are **create-only** and **have NO spam /
  abuse protection** (no App Check, no rate limit, no captcha, no auth
  requirement on the create).
- They are **managed only in the Firebase console**. There is **no
  `firestore.rules` in this repo** and **no `firestore` block in `firebase.json`**
  (verified: `firebase.json` is hosting-only; no tracked `firestore.rules`).

This is an **open posture, not a solved problem.** Anyone can create `inquiries`
docs at will; the only backstop downstream is that the function sends a canned
email. Treat "harden this" as pending work, and never describe the current rules
as if they were adequate.

Two follow-ups, both **candidate / open** (do not present as done):

1. **Get the rules into source** so they are reviewable and versioned. Runbook:
   `references/rules-export-runbook.md`. Helper: `scripts/fetch-live-firestore-rules.sh`.
2. **Add spam/abuse hardening** once rules are in source: Firebase App Check on
   the web app (note: `firebase_app_check` is **not** currently a dependency —
   `pubspec.yaml` has `cloud_firestore` + `firebase_core` only, so this needs a
   new package + registration), and/or a rules condition constraining field
   shape/size. Candidates are enumerated in `references/rules-export-runbook.md`.
   Do not implement silently — these change who can write and require the
   maintainer's call.

To confirm what the live rules actually are before you touch them (this repo
cannot tell you — they are console-side), see the verification path in
`references/rules-export-runbook.md`.

## When NOT to use this skill

| You are working on...                                              | Go to |
| ------------------------------------------------------------------ | ----- |
| The email send, Microsoft Graph, `sendMail`, or the `inquiryCreated` trigger's internals / security | The **functions repo** at `../anaheim_technologies_website_functions` (its own `.claude/skills`) — a **separate** repo, not a sibling skill here |
| How `ContactUsBloc` / the `/contact` form is structured in the app (bloc states, routing, responsive layout) | `ato-website-architecture` |
| Build/run/CI/deploy mechanics, the single-project prod-only model, how prod builds ship | `ato-website-build-deploy` |
| Writing tests for the contact form / adding a CI test step         | `ato-website-testing-and-cleanup` |
| Editing marketing copy on the `/contact` page                      | `ato-website-content-and-brand` |

The functions repo is a **different git repo**. When you need its side of the
contract, open its files directly by path
(`../anaheim_technologies_website_functions/functions/src/index.ts`); you cannot
`load` its skills from this repo.

## Provenance and maintenance

Authored 2026-07-07 from direct inspection of this repo and the sibling functions
repo. Binding maintainer decisions: A3 (create-only console rules, no spam
protection, document + export runbook) and A4 (single prod project;
`dev_inquiries` gap is by design; emulators are the dev path).

Repo-of-origin note for cited history (website repo, shallow): the contact write
was added in `ae33364` ("added contact us functionality to send email"); the
`inquired_on` field in `d1daf29` ("added inquire_on date when saving user
inquiries").

Re-verify volatile facts:

```bash
# The write contract (fields, collection, prefix logic):
sed -n '26,52p' lib/features/contact_us/bloc/contact_us_bloc.dart

# Prod CI still builds main_production without --dart-define=ENVIRONMENT:
grep -n "build web\|dart-define\|ENVIRONMENT" .github/workflows/main.yaml

# Still no firestore.rules / firestore block in source, single project:
ls firestore.rules 2>/dev/null || echo "still console-only"
grep -n firestore firebase.json || echo "firebase.json still hosting-only"
cat .firebaserc                       # expect single default: anaheim-technologies

# The trigger still only watches unprefixed 'inquiries' (other repo):
grep -n "onDocumentCreated" ../anaheim_technologies_website_functions/functions/src/index.ts

# What the LIVE console rules actually are (see references for auth caveats):
scripts/fetch-live-firestore-rules.sh anaheim-technologies
```
