#!/usr/bin/env bash
# Run the Flutter test suite with coverage for the ATO website.
# Regenerates l10n first (test/helpers/pump_app.dart depends on AppLocalizations).
# Toolchain (fvm 3.41.6) is owned by the ato-website-build-deploy skill.
#
# NOTE (2026-07-07): the committed suite is broken counter boilerplate and WILL
# fail until you replace it (see the testing-and-cleanup skill). This script is
# the command you run once real tests exist.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cd "$REPO_ROOT"

if ! command -v fvm >/dev/null 2>&1; then
  echo "fvm not found on PATH. See the ato-website-build-deploy skill." >&2
  exit 1
fi

echo "== pub get =="
fvm flutter pub get
echo "== gen-l10n =="
fvm flutter gen-l10n
echo "== test (coverage -> coverage/lcov.info) =="
fvm flutter test --coverage "$@"
