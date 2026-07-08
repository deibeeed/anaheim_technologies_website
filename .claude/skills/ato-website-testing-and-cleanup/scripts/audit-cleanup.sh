#!/usr/bin/env bash
# Read-only audit of the sanctioned cleanup backlog (testing-and-cleanup skill,
# Part 3). Reports whether each debt item is still present. Mutates nothing.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cd "$REPO_ROOT"

hr() { printf '%s\n' "------------------------------------------------------------"; }
echo "Cleanup-backlog audit for: $REPO_ROOT"
hr

echo "[1] Dead counter scaffold + broken tests"
[ -d lib/counter ] && echo "  -> lib/counter/ STILL PRESENT" || echo "  -> lib/counter/ gone"
[ -d test/counter ] && echo "  -> test/counter/ STILL PRESENT" || echo "  -> test/counter/ gone"
grep -q "find.byType(CounterPage)" test/app/view/app_test.dart 2>/dev/null \
  && echo "  -> test/app/view/app_test.dart STILL asserts CounterPage (broken)" \
  || echo "  -> app_test.dart fixed/removed"
hr

echo "[2] Empty Spanish l10n"
if [ -f lib/l10n/arb/app_es.arb ]; then
  echo "  -> app_es.arb present (only counterAppBarTitle expected)"
else
  echo "  -> app_es.arb gone"
fi
hr

echo "[3] Vestigial platform scaffolds (web-only reality)"
for d in android ios windows macos linux; do
  [ -d "$d" ] && echo "  -> $d/ present"
done
grep -q "UnsupportedError" lib/firebase_options.dart 2>/dev/null \
  && echo "  -> firebase_options.dart confirms web-only (non-web throws)"
hr

echo "[4] Stale remote branches + go_router pin"
if git rev-parse --git-dir >/dev/null 2>&1; then
  git branch -r 2>/dev/null | grep -E "dependabot|versions/2" | sed 's/^/  -> /' || echo "  -> none"
else
  echo "  -> not a git checkout here; run 'git branch -r' in the repo"
fi
grep -n "go_router" pubspec.yaml | sed 's/^/  pin: /'
hr

echo "[5] Orphaned under-construction assets"
ls assets/under-construction*.png 2>/dev/null | sed 's/^/  -> /' || echo "  -> gone"
hr

echo "[6] Committed Firebase hosting cache"
if git rev-parse --git-dir >/dev/null 2>&1; then
  git ls-files 2>/dev/null | grep "\.firebase/" | sed 's/^/  -> tracked: /' || echo "  -> not tracked"
else
  ls .firebase/*.cache 2>/dev/null | sed 's/^/  -> present: /' || echo "  -> none"
fi
hr

echo "[7] Unused imports (spot check; run 'fvm flutter analyze' for full list)"
grep -q "package:intl/intl.dart" lib/utils/constants.dart 2>/dev/null \
  && echo "  -> constants.dart still imports intl (unused)"
grep -q "dart:math" lib/features/services/screen/services_screen.dart 2>/dev/null \
  && echo "  -> services_screen.dart still imports dart:math (unused)"
grep -q "dart:math" lib/features/projects/screen/projects_screen.dart 2>/dev/null \
  && echo "  -> projects_screen.dart still imports dart:math (unused)"
hr

echo "[8] LICENSE vs MIT badge"
[ -f LICENSE ] && echo "  -> LICENSE present" || echo "  -> NO LICENSE file (README claims MIT)"
hr
echo "Done. This audit is read-only. See references/cleanup-backlog.md for actions."
