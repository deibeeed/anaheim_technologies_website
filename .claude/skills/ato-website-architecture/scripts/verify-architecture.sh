#!/usr/bin/env bash
# Re-verify the load-bearing facts in ato-website-architecture/SKILL.md against the repo.
# Read-only. Prints PASS/FAIL per anchor; exits non-zero if any FAIL.
# Authored 2026-07-07. Run from anywhere.
set -u

REPO="/Users/deibeeed/Projects/AnaheimTechnologies/ato_website/anaheim_technologies_website"
cd "$REPO" || { echo "repo not found: $REPO"; exit 2; }

fail=0
check() { # desc, command...
  local desc="$1"; shift
  if "$@" >/dev/null 2>&1; then
    printf 'PASS  %s\n' "$desc"
  else
    printf 'FAIL  %s\n' "$desc"; fail=1
  fi
}

check "single ShellRoute in app.dart"        grep -q "ShellRoute(" lib/app/view/app.dart
check "shell wraps HomeScreen(child: child)"  grep -q "HomeScreen(child: child)" lib/app/view/app.dart
check "transition helper exists"              grep -q "buildPageWithDefaultTransition" lib/utils/router_utils.dart
check "go_router 6 .location still used"      grep -q "GoRouter.of(context).location" lib/features/home/screen/home_screen.dart
check "breakpoints 600/840 intact"            grep -q "deviceWidth < 600" lib/utils/screen_utils.dart
check "responsive globals recomputed in App"  grep -q "Constants.isExpandedScreen =" lib/app/view/app.dart
check "Constants static booleans present"     grep -q "static bool isCompactScreen" lib/utils/constants.dart
check "prefix logic dev_ on development"       grep -q "return 'dev_';" lib/features/contact_us/bloc/contact_us_bloc.dart
check "writes {prefix}inquiries collection"   grep -q "inquiries" lib/features/contact_us/bloc/contact_us_bloc.dart
check "MasterDetailScreen home = projects_content_screen.dart" \
      grep -q "class MasterDetailScreen" lib/features/projects/screen/projects_content_screen.dart
check "Firebase web-only (android throws)"    grep -q "have not been configured for android" lib/firebase_options.dart

echo "--- pinned versions (as of 2026-07-07: go_router 6.5.2, flutter_bloc 8.1.1) ---"
for p in go_router flutter_bloc bloc cloud_firestore firebase_core; do
  v=$(awk "/^  $p:/{f=1} f&&/version:/{print \$2; exit}" pubspec.lock)
  printf '  %-16s %s\n' "$p" "$v"
done

exit $fail
