#!/usr/bin/env bash
# Attach an Android AVD to Orca's embedded pane, then start the live Flutter app.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -n "${ORCA_CLI_COMMAND:-}" ]]; then
  ORCA_CLI="$ORCA_CLI_COMMAND"
elif [[ -n "${ORCA_DEV_REPO_ROOT:-}" ]]; then
  ORCA_CLI="orca-dev"
elif [[ "$(uname -s)" == "Linux" ]]; then
  ORCA_CLI="orca-ide"
else
  ORCA_CLI="orca"
fi

if ! command -v "$ORCA_CLI" >/dev/null 2>&1; then
  echo "Orca CLI not found: $ORCA_CLI" >&2
  exit 1
fi

"$ORCA_CLI" status --json >/dev/null

requested_device="${FORGE_ANDROID_DEVICE:-}"
attach_target="$requested_device"
if [[ -z "$attach_target" ]]; then
  devices_json="$("$ORCA_CLI" emulator devices --json)"
  attach_target="$(
    python -c '
import json, sys
payload = json.load(sys.stdin)
devices = payload.get("result", [])
android = [device for device in devices if device.get("backend") == "android"]
booted = next((device for device in android if device.get("state") == "booted"), None)
selected = booted or next((device for device in android if device.get("isAvailable")), None)
if selected:
    print(selected.get("id") or selected.get("name", ""))
' <<<"$devices_json"
  )"
fi

if [[ -z "$attach_target" ]]; then
  cat >&2 <<'EOF'
No Android device or AVD is available to Orca.
Create the project AVD in Android Studio Device Manager, then retry.
Recommended name: Forge_Dance_API_35
EOF
  exit 1
fi

# Reattaching an already-active Android pane tears down adb forwards while
# scrcpy reconnects. That races Flutter's VM-service forwarding and can leave
# the app running while `flutter run` exits with Connection refused. Reuse the
# active pane when Orca can already read Android logcat. An explicitly requested
# device still forces attachment so the caller's target is respected.
if [[ -z "$requested_device" ]] &&
  "$ORCA_CLI" emulator logcat --lines 1 --worktree active --json >/dev/null 2>&1; then
  attached_device="$attach_target"
  echo "Using Android device already attached to Orca: $attached_device"
else
  echo "Attaching $attach_target to Orca's Android pane..."
  attach_json="$(
    "$ORCA_CLI" emulator attach "$attach_target" \
      --worktree active \
      --focus \
      --json
  )"
  attached_device="$(
    python -c '
import json, sys
payload = json.load(sys.stdin)
print(payload.get("result", {}).get("info", {}).get("deviceUdid", ""))
' <<<"$attach_json"
  )"

  if [[ -z "$attached_device" ]]; then
    echo "Orca attached the pane but did not return an Android device id." >&2
    exit 1
  fi

  # Give Orca's scrcpy transport time to finish its initial adb-forward setup
  # before Flutter creates the VM-service forward.
  sleep "${FORGE_ORCA_ATTACH_SETTLE_SECONDS:-10}"
fi

export FORGE_ANDROID_DEVICE="$attached_device"
echo "Orca Android controls target $FORGE_ANDROID_DEVICE."
echo "Use another terminal for: $ORCA_CLI emulator ax --device $FORGE_ANDROID_DEVICE --json"

set +e
bash tool/run_live_flutter.sh android "$@"
flutter_exit=$?
set -e

# A fresh Orca Android attachment can briefly race Flutter's first adb
# VM-service forward. Flutter uses exit 2 for that tooling connection failure.
# By the time it returns, Orca's transport is settled; retry without attaching
# again. Build failures use a different exit status and are not retried.
if [[ $flutter_exit -eq 2 ]]; then
  echo "Flutter lost its initial VM-service connection; retrying once without reattaching Orca..." >&2
  sleep 2
  exec bash tool/run_live_flutter.sh android "$@"
fi

exit "$flutter_exit"
