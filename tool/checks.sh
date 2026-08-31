#!/usr/bin/env bash
# Single source of truth for "is this change done?"
#
# Run before every commit:   bash tool/checks.sh
# CI runs exactly this script, so local green == CI green.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -x .fvm/flutter_sdk/bin/flutter ]]; then
  FLUTTER=(.fvm/flutter_sdk/bin/flutter)
  DART=(.fvm/flutter_sdk/bin/dart)
elif command -v fvm >/dev/null 2>&1; then
  FLUTTER=(fvm flutter)
  DART=(fvm dart)
else
  FLUTTER=(flutter)
  DART=(dart)
fi

echo "==> flutter pub get"
"${FLUTTER[@]}" pub get

echo "==> generate localization keys"
"${DART[@]}" run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations

echo "==> generate riverpod/freezed/json code"
"${DART[@]}" run build_runner build

echo "==> flutter analyze"
"${FLUTTER[@]}" analyze

echo "==> flutter test"
"${FLUTTER[@]}" test

echo ""
echo "ALL CHECKS PASSED"
