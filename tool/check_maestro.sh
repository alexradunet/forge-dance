#!/usr/bin/env bash
# Android black-box scenarios. Requires an explicitly selected disposable emulator.
set -euo pipefail
cd "$(dirname "$0")/.."

fail() { echo "$*" >&2; exit 1; }
if [[ "${1:-}" == "--help" ]]; then
  echo 'Usage: FORGE_ANDROID_DEVICE=emulator-5556 FORGE_MAESTRO_ALLOW_CLEAR=1 bash tool/check_maestro.sh [flow.yaml]'
  echo 'Builds and installs a release APK, then runs Maestro. WARNING: scenarios erase app data.'
  echo 'Optional: FORGE_MAESTRO_APK=/absolute/path/app.apk skips the build.'
  exit 0
fi
[[ $# -le 1 ]] || fail 'Expected at most one flow path; see --help.'
[[ "${FORGE_MAESTRO_ALLOW_CLEAR:-}" == 1 ]] || fail 'Scenarios erase Forge Dance data. Use a disposable emulator and set FORGE_MAESTRO_ALLOW_CLEAR=1.'
device="${FORGE_ANDROID_DEVICE:-}"
[[ "$device" == emulator-* ]] || fail 'Set FORGE_ANDROID_DEVICE to an explicit Android emulator serial (not a physical device).'
flow="${1:-.maestro}"
[[ -e "$flow" ]] || fail "Flow not found: $flow"

sdk="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Android/Sdk}}"
export PATH="$sdk/platform-tools:$HOME/.maestro/bin:$PATH"
command -v adb >/dev/null || fail 'adb not found. Set ANDROID_HOME to your Android SDK.'
command -v maestro >/dev/null || fail 'Maestro not found. See .maestro/README.md for installation.'
command -v java >/dev/null || fail 'Java 17+ is required by Maestro.'
[[ "$(adb -s "$device" get-state)" == device ]] || fail "Emulator is not connected: $device"
[[ "$(adb -s "$device" shell getprop sys.boot_completed | tr -d '\r')" == 1 ]] || fail 'Wait for the emulator to finish booting.'

apk="${FORGE_MAESTRO_APK:-}"
if [[ -z "$apk" ]]; then
  if [[ -x .fvm/flutter_sdk/bin/flutter ]]; then
    FLUTTER=(.fvm/flutter_sdk/bin/flutter)
    DART=(.fvm/flutter_sdk/bin/dart)
  elif command -v fvm >/dev/null; then
    FLUTTER=(fvm flutter)
    DART=(fvm dart)
  else
    FLUTTER=(flutter)
    DART=(dart)
  fi
  "${FLUTTER[@]}" pub get
  "${DART[@]}" run easy_localization:generate -f keys -o locale_keys.g.dart --source-dir assets/translations
  "${DART[@]}" run build_runner build
  "${FLUTTER[@]}" build apk --release
  apk=build/app/outputs/flutter-apk/app-release.apk
fi
[[ -f "$apk" ]] || fail "APK not found: $apk"
adb -s "$device" install -r "$apk"

# Separate runs retain their own reports and screenshots (all gitignored).
mkdir -p build
results="$(mktemp -d "$PWD/build/maestro-XXXXXXXX")"
echo "Maestro results: $results"
maestro --device "$device" test \
  --format junit --output "$results/report.xml" \
  --test-output-dir "$results" --debug-output "$results" \
  "$flow"
