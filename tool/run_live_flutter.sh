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

case "$target" in
  linux)
    echo "Starting Forge Dance on Linux."
    exec "${FLUTTER[@]}" run -d linux "$@"
    ;;
  web)
    port="${FORGE_LIVE_WEB_PORT:-7357}"
    echo "Starting Forge Dance at http://127.0.0.1:$port"
    exec "${FLUTTER[@]}" run \
      -d web-server \
      --web-hostname=127.0.0.1 \
      --web-port="$port" \
      "$@"
    ;;
  android)
    device="${FORGE_ANDROID_DEVICE:-android}"
    echo "Starting Forge Dance on Android device $device."
    exec "${FLUTTER[@]}" run -d "$device" "$@"
    ;;
  *)
    cat >&2 <<'EOF'
Usage: bash tool/run_live_flutter.sh [linux|web|android] [flutter run arguments]

  linux   Fast native UI loop.
  web     Stable browser URL.
  android Android device.
EOF
    exit 64
    ;;
esac
