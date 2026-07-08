#!/usr/bin/env bash
# build-web.sh — reproduce the CI production web build locally.
#
# Mirrors .github/workflows/main.yaml steps 3-6 (pub get -> gen-l10n ->
# analyze errors-only -> build web --release -t lib/main_production.dart).
# Output lands in build/web (gitignored). It does NOT deploy.
#
# Usage:  ./scripts/build-web.sh
# Run from anywhere; the script cd's to the repo root (two levels above
# .claude/skills/ato-website-build-deploy/scripts/).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# scripts/ -> ato-website-build-deploy/ -> skills/ -> .claude/ -> repo root
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"
cd "${REPO_ROOT}"

# This repo has no system Flutter; the pinned SDK is driven by fvm (.fvmrc=3.41.6).
if ! command -v fvm >/dev/null 2>&1; then
  echo "ERROR: fvm not found on PATH. Install fvm (e.g. 'brew install fvm')." >&2
  echo "The website pins Flutter 3.41.6 via .fvmrc; do not use a bare 'flutter'." >&2
  exit 1
fi

echo "==> Flutter SDK (expect 3.41.6 / Dart 3.11.4):"
fvm flutter --version | head -1

echo "==> [1/4] fvm flutter pub get"
fvm flutter pub get

echo "==> [2/4] fvm flutter gen-l10n"
fvm flutter gen-l10n

echo "==> [3/4] fvm flutter analyze (errors only, matches CI)"
fvm flutter analyze --no-fatal-warnings --no-fatal-infos

echo "==> [4/4] fvm flutter build web --release -t lib/main_production.dart"
fvm flutter build web --release -t lib/main_production.dart

echo "==> Done. Artifact in ${REPO_ROOT}/build/web (gitignored)."
echo "    To ship it manually: firebase deploy --only hosting   (deploys LIVE)."
echo "    Normally push to master (live) or open a PR (preview) instead."
