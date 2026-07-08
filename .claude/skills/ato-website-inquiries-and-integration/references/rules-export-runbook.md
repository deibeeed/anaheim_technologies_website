# Runbook: export the console-managed `inquiries` rules into source, then harden

As of 2026-07-07 the Firestore security rules for `inquiries` are **create-only,
have no spam/abuse protection, and live only in the Firebase console** (there is
no `firestore.rules` in this repo and no `firestore` block in `firebase.json`).
This is maintainer decision A3 and it is an **open** posture, not a finished one.

This runbook does two separable things:
1. **Read** the live rules and commit them into this repo as source of truth
   (low risk; changes nothing that is deployed).
2. **Harden** them (candidates only; each one changes who can write — the
   maintainer decides, and any change must be deployed deliberately).

Do step 1 before step 2 — you cannot review or safely edit rules you have not
first captured as text.

---

## Step 0 — know your project and account

- Firebase project: **`anaheim-technologies`** (single project; `.firebaserc`
  has only `default`). There is no dev/staging project.
- The account that reads/deploys rules must have access to that project. Note
  the known gotcha: your `gcloud` CLI account and your Application Default
  Credentials (ADC) account can differ, and project access does not carry across
  them. If a read 403s, check *which* identity the token belongs to
  (`gcloud auth list`, `gcloud config get-value account`) before assuming you
  lack access.

---

## Step 1a — READ the live rules (pick one)

**Option A — Firebase console (simplest, zero tooling, always works).**
Firebase console -> Firestore Database -> **Rules** tab. The full rules text is
shown there. This is the current source of truth; copy it verbatim.

**Option B — REST API via a gcloud token** (`scripts/fetch-live-firestore-rules.sh`).
The Firebase CLI has **no** `firestore:rules get` subcommand (verified against
firebase-tools 14.27.0 on 2026-07-07 — the only `firestore:*` verbs are
`delete`, `indexes`, `databases:*`, `backups:*`, etc.). The documented way to
fetch the *active* ruleset programmatically is the Firebase Security Rules REST
API (`firebaserules.googleapis.com`):

```
GET /v1/projects/{project}/releases/cloud.firestore      -> { rulesetName: "projects/.../rulesets/UUID" }
GET /v1/projects/{project}/rulesets/{UUID}               -> source.files[].content   (the rules text)
```

The helper script wraps both calls. It needs `gcloud auth print-access-token`
and `jq`. **UNVERIFIED against the live project during authoring** (setting an
active project / minting a live token was out of scope) — the endpoint shapes are
from Google's public Firebase Security Rules API docs. Run it, then eyeball the
output before trusting it; if it errors, fall back to Option A.

**Do NOT use `firebase init firestore` to "download" the rules.** It scaffolds
`firestore.rules` + `firestore.indexes.json` and rewrites `firebase.json`
interactively, and can overwrite with a template default rather than the live
rules. Capture the text first (A or B), then create the file by hand (Step 1b).

---

## Step 1b — commit the rules as source of truth

1. Create `firestore.rules` at the repo root and paste the exact live rules text.
   Expect something close to create-only for `inquiries`, e.g.:

   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /inquiries/{docId} {
         allow create: if true;   // <- open create, no spam protection (the A3 reality)
         allow read, update, delete: if false;
       }
     }
   }
   ```

   Paste what the console/API actually returns — do not assume the block above is
   byte-identical to production. It illustrates the *shape* to expect.

2. Wire it into `firebase.json` (currently hosting-only). Add a sibling block:

   ```json
   "firestore": { "rules": "firestore.rules" }
   ```

   (Add `"indexes": "firestore.indexes.json"` too only if you also capture
   indexes; not required for a rules-only export.)

3. Commit. This is now the reviewable source of truth. **This alone deploys
   nothing.**

### Deploy safety after wiring firestore into firebase.json

- **CI is safe.** This repo's CI (`.github/workflows/main.yaml`) deploys via
  `FirebaseExtended/action-hosting-deploy@v0`, which pushes **hosting only** — it
  never runs `firebase deploy`, so it will not push rules.
- **A local bare `firebase deploy` is NOT safe** once the `firestore` block
  exists: it would deploy hosting **and** firestore rules together. To push rules
  on purpose and only rules: `firebase deploy --only firestore:rules`. Never let
  a rules deploy be an accident.
- Decide deliberately whether rules become **source-managed going forward**. If
  yes, the repo is now authoritative and console edits will be clobbered by the
  next `firebase deploy --only firestore:rules`; keep future rule changes in the
  repo. If you only wanted a versioned snapshot, say so in the commit message and
  keep deploying rules from the console.

---

## Step 2 — hardening candidates (OPEN — maintainer's call, deploy deliberately)

All of these are **candidates**, listed so a future engineer does not have to
rediscover them. None is implemented. Each changes who can write `inquiries`, so
each needs the maintainer's decision and a deliberate `--only firestore:rules`
(and, for App Check, app-side wiring) deploy. Verify the contact form still
submits after any of them.

1. **Field-shape constraint in the rule.** Tighten `allow create` to require the
   exact contract and cap sizes, e.g. only the four known keys, each a string
   (except `inquired_on` an int), with `message` length-bounded. Cheap, no new
   dependency, blocks garbage/oversized docs. Does not stop a determined bot.

2. **Firebase App Check on the web app + `allow create: if request.auth != null`
   is NOT the right lever here** (the form is anonymous). App Check is: it
   attests the request came from your real web app (reCAPTCHA provider on web),
   and rules can require `request.appCheck` context. **Cost:** add the
   `firebase_app_check` package (not currently in `pubspec.yaml` — today it is
   just `cloud_firestore` + `firebase_core`), register App Check in web init,
   register the site key in the console, and enforce on Firestore. Highest
   effort, strongest bot resistance.

3. **A captcha / challenge in the form** before the write — client-side friction;
   weaker than App Check and adds UI work, but no rules change. Lowest-trust.

4. **Rate limiting** is not expressible in Firestore rules alone; it would need a
   counter doc + rule, or moving the create behind an authenticated/App-Check'd
   callable. Note it as harder; do not pretend a rule can do per-IP limiting.

Recommended sequencing if hardening is greenlit: (1) field-shape rule first
(cheap, immediate), then (2) App Check for real bot resistance.
