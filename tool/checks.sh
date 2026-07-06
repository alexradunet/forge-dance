#!/usr/bin/env bash
# Single source of truth for "is this change done?"
#
# Run before every commit:   bash tool/checks.sh
# CI runs exactly this script, so local green == CI green.
set -euo pipefail
cd "$(dirname "$0")/.."

if command -v fvm >/dev/null 2>&1; then
  FLUTTER=(fvm flutter)
else
  FLUTTER=(flutter)
fi

echo "==> flutter pub get"
"${FLUTTER[@]}" pub get

echo "==> generate localization keys"
"${FLUTTER[@]}" pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations

echo "==> generate riverpod/freezed/json code"
"${FLUTTER[@]}" pub run build_runner build --delete-conflicting-outputs

echo "==> riverpod lints (custom_lint)"
"${FLUTTER[@]}" pub run custom_lint

echo "==> flutter analyze"
"${FLUTTER[@]}" analyze

echo "==> flutter test"
"${FLUTTER[@]}" test

echo ""
echo "ALL CHECKS PASSED"
