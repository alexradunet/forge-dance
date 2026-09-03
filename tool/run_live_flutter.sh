#!/usr/bin/env bash
# Start a debug Flutter process that the Dart MCP server can discover through DTD.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -x .fvm/flutter_sdk/bin/flutter ]]; then
  FLUTTER=(.fvm/flutter_sdk/bin/flutter)
elif command -v fvm >/dev/null 2>&1; then
  FLUTTER=(fvm flutter)
else
  FLUTTER=(flutter)
fi

target="${1:-linux}"
if [[ $# -gt 0 ]]; then
  shift
fi

require_firebase_emulators() {
  local emulator_port
  for emulator_port in 9099 8080; do
    if ! timeout 1 bash -c "</dev/tcp/127.0.0.1/$emulator_port" 2>/dev/null; then
      cat >&2 <<EOF
Firebase emulator port $emulator_port is unavailable.
Start the safe local backend first:
  firebase emulators:start --only auth,firestore
EOF
      exit 1
    fi
  done
}

case "$target" in
  linux)
    echo "Starting Forge Dance on Linux (UI-only; Firebase is unavailable)."
    exec "${FLUTTER[@]}" run -d linux "$@"
    ;;
  web)
    require_firebase_emulators
    port="${FORGE_LIVE_WEB_PORT:-7357}"
    echo "Starting Forge Dance at http://127.0.0.1:$port"
    echo "Firebase Auth and Firestore are pinned to local emulators."
    exec "${FLUTTER[@]}" run \
      -d web-server \
      --web-hostname=127.0.0.1 \
      --web-port="$port" \
      --dart-define=USE_FIREBASE_EMULATOR=true \
      "$@"
    ;;
  android)
    require_firebase_emulators
    device="${FORGE_ANDROID_DEVICE:-android}"
    echo "Starting Forge Dance on Android device $device."
    echo "Firebase Auth and Firestore are pinned to the host emulator suite."
    exec "${FLUTTER[@]}" run \
      -d "$device" \
      --dart-define=USE_FIREBASE_EMULATOR=true \
      --dart-define=FIREBASE_EMULATOR_HOST=10.0.2.2 \
      "$@"
    ;;
  *)
    cat >&2 <<'EOF'
Usage: bash tool/run_live_flutter.sh [linux|web|android] [flutter run arguments]

  linux   Fast native UI loop without Firebase.
  web     Stable browser URL with mandatory Auth/Firestore emulators.
  android Android device with mandatory Auth/Firestore emulators.
EOF
    exit 64
    ;;
esac
