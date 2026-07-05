#!/usr/bin/env bash
# Single source of truth for "is this change done?"
#
# Run before every commit:   bash tool/checks.sh
# CI runs exactly this script, so local green == CI green.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "==> flutter pub get"
flutter pub get

echo "==> generate localization keys"
flutter pub run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations

echo "==> generate riverpod/freezed/json code"
flutter pub run build_runner build --delete-conflicting-outputs

echo "==> riverpod lints (custom_lint)"
flutter pub run custom_lint

echo "==> flutter analyze"
flutter analyze

echo "==> flutter test"
flutter test

echo ""
echo "ALL CHECKS PASSED"
