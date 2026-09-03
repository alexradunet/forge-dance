#!/usr/bin/env bash
# Capture the current Android framebuffer for agent or human visual review.
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -n "${ANDROID_HOME:-}" && -x "$ANDROID_HOME/platform-tools/adb" ]]; then
  ADB="$ANDROID_HOME/platform-tools/adb"
elif [[ -n "${ANDROID_SDK_ROOT:-}" && -x "$ANDROID_SDK_ROOT/platform-tools/adb" ]]; then
  ADB="$ANDROID_SDK_ROOT/platform-tools/adb"
elif command -v adb >/dev/null 2>&1; then
  ADB="$(command -v adb)"
elif [[ -x "$HOME/Android/Sdk/platform-tools/adb" ]]; then
  ADB="$HOME/Android/Sdk/platform-tools/adb"
elif [[ -x "$HOME/Library/Android/sdk/platform-tools/adb" ]]; then
  ADB="$HOME/Library/Android/sdk/platform-tools/adb"
else
  echo "adb not found; install the Android SDK or set ANDROID_HOME." >&2
  exit 1
fi

device="${FORGE_ANDROID_DEVICE:-}"
if [[ -z "$device" ]]; then
  device="$($ADB devices | awk '$2 == "device" && $1 ~ /^emulator-/ { print $1; exit }')"
fi
if [[ -z "$device" ]]; then
  echo "No booted Android emulator found." >&2
  exit 1
fi

mkdir -p build/live
output="build/live/android-emulator.png"
"$ADB" -s "$device" exec-out screencap -p >"$output"
echo "$output"
