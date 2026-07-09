#!/usr/bin/env bash
# Fetch the LIVE Firestore security rules for a Firebase project and print the
# rules text to stdout. Read-only: it only performs GETs against the Firebase
# Security Rules REST API (firebaserules.googleapis.com).
#
# Why this exists: firebase-tools has NO `firestore:rules get` subcommand
# (verified against firebase-tools 14.27.0, 2026-07-07), and `firebase init
# firestore` can overwrite local rules with a template. This wraps the two
# documented REST calls instead.
#
# CAVEAT (2026-07-07): the endpoint shapes are from Google's public Firebase
# Security Rules REST API docs; this script was NOT executed against the live
# project during authoring (no active project / live token in scope). Eyeball the
# output; if it errors or looks wrong, use the console Rules tab instead
# (references/rules-export-runbook.md, Option A).
#
# Requires: gcloud (authenticated with access to the project) and jq.
#
# Usage:
#   scripts/fetch-live-firestore-rules.sh [PROJECT_ID]
# Default PROJECT_ID: anaheim-technologies (this repo's single project).

set -euo pipefail

PROJECT="${1:-anaheim-technologies}"
API="https://firebaserules.googleapis.com/v1"

command -v gcloud >/dev/null 2>&1 || { echo "error: gcloud not found on PATH" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo "error: jq not found on PATH" >&2; exit 1; }

TOKEN="$(gcloud auth print-access-token)" || {
  echo "error: could not mint an access token. Check 'gcloud auth list' and that" >&2
  echo "       the active account has access to project '$PROJECT'." >&2
  exit 1
}

echo ">> account: $(gcloud config get-value account 2>/dev/null)  project: $PROJECT" >&2

# 1. Resolve the active ruleset name from the cloud.firestore release.
RELEASE_JSON="$(curl -fsS -H "Authorization: Bearer $TOKEN" \
  "$API/projects/$PROJECT/releases/cloud.firestore")" || {
  echo "error: failed to read release cloud.firestore for '$PROJECT' (403 => wrong identity/access)." >&2
  exit 1
}

RULESET_NAME="$(printf '%s' "$RELEASE_JSON" | jq -r '.rulesetName')"
if [ -z "$RULESET_NAME" ] || [ "$RULESET_NAME" = "null" ]; then
  echo "error: no rulesetName in release response:" >&2
  printf '%s\n' "$RELEASE_JSON" >&2
  exit 1
fi
echo ">> active ruleset: $RULESET_NAME" >&2

# 2. Fetch that ruleset and print each source file's content.
RULESET_JSON="$(curl -fsS -H "Authorization: Bearer $TOKEN" "$API/$RULESET_NAME")" || {
  echo "error: failed to fetch ruleset $RULESET_NAME" >&2
  exit 1
}

printf '%s' "$RULESET_JSON" | jq -r '.source.files[].content'
