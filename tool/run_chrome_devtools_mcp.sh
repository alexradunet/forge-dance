#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

browser_path="${CHROME_PATH:-}"
if [[ -z "$browser_path" ]]; then
  for candidate in google-chrome-stable google-chrome chromium chromium-browser; do
    if command -v "$candidate" >/dev/null 2>&1; then
      browser_path="$(command -v "$candidate")"
      break
    fi
  done
fi

if [[ -z "$browser_path" && "$(uname -s)" == "Darwin" ]]; then
  macos_chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  if [[ -x "$macos_chrome" ]]; then
    browser_path="$macos_chrome"
  fi
fi

args=(
  -y
  chrome-devtools-mcp@1.8.0
  --isolated
  --no-usage-statistics
  --no-performance-crux
  --redact-network-headers
  --screenshot-format=webp
  --screenshot-max-width=1600
  --screenshot-max-height=1200
)

if [[ -n "$browser_path" ]]; then
  args+=("--executable-path=$browser_path")
fi

exec npx "${args[@]}"
