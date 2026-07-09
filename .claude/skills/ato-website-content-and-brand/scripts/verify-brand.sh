#!/usr/bin/env bash
# Re-verify the ATO website brand & content facts asserted by
# ato-website-content-and-brand. Read-only. Run from anywhere.
#
#   bash .claude/skills/ato-website-content-and-brand/scripts/verify-brand.sh
#
# Prints each asserted fact and whether it still holds. Exit 0 if all pass.
set -u

# Resolve repo root = two levels up from this script's .claude/skills/<skill>/scripts dir.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
cd "$REPO_ROOT" || { echo "cannot cd to repo root $REPO_ROOT"; exit 2; }

fail=0
check() { # desc, pattern, file
  local desc="$1" pat="$2" file="$3"
  if grep -Eq "$pat" "$file" 2>/dev/null; then
    printf 'OK   %s\n' "$desc"
  else
    printf 'DRIFT %s  (pattern /%s/ not found in %s)\n' "$desc" "$pat" "$file"
    fail=1
  fi
}

echo "== Brand color tokens (lib/utils/color_utils.dart) =="
check "gradientTop #1B282F"     '0xFF1B282F' lib/utils/color_utils.dart
check "gradientBottom #0D161A"  '0xFF0D161A' lib/utils/color_utils.dart
check "signature green #41F39E" '0xFF41F39E' lib/utils/color_utils.dart
check "foreground #D3D3D3"      '0xFFD3D3D3' lib/utils/color_utils.dart

echo "== Splash (web/index.html) =="
check "splash overlay #0A0A0A"          '#0A0A0A'              web/index.html
check "splash green #3EE58C (green nit)" '3EE58C'              web/index.html
check "dismiss on flutter-first-frame"   'flutter-first-frame' web/index.html
check "splash loads assets/fonts/*.otf"  'assets/fonts/.*\.otf' web/index.html

echo "== Bundled fonts (pubspec.yaml) =="
check "Mechsuit from fonts/Mechsuit.otf" 'fonts/Mechsuit\.otf' pubspec.yaml
check "Plavsky from fonts/Plavsky.otf"   'fonts/Plavsky\.otf'  pubspec.yaml

echo "== Base font (lib/app/view/app.dart) =="
check "Noto Sans via google_fonts" 'notoSansTextTheme' lib/app/view/app.dart

echo "== l10n still boilerplate-only (lib/l10n/arb/app_en.arb) =="
if grep -q 'counterAppBarTitle' lib/l10n/arb/app_en.arb 2>/dev/null \
   && [ "$(grep -c '"@' lib/l10n/arb/app_en.arb 2>/dev/null)" -le 2 ]; then
  printf 'OK   app_en.arb holds only the counter boilerplate key\n'
else
  printf 'DRIFT app_en.arb changed — real l10n keys may now exist; revisit the l10n section\n'
  fail=1
fi

echo "== Key content anchors present =="
check "CTA https://bit.ly/CallATO" 'bit\.ly/CallATO'   lib/features/home/screen/home_screen_content.dart
check "CURRENTLY BUILDING / Loooans teaser" 'CURRENTLY BUILDING' lib/features/home/screen/home_screen_content.dart
check "case study BPV Loan Monitoring" 'BPV Loan Monitoring' lib/features/projects/screen/projects_screen.dart
check "case study [PROTOTYPE] HLP Systems" '\[PROTOTYPE\] HLP Systems' lib/features/projects/screen/projects_screen.dart

echo
if [ "$fail" -eq 0 ]; then
  echo "All brand/content facts verified."
else
  echo "One or more facts drifted — update SKILL.md + references/ accordingly."
fi
exit "$fail"
