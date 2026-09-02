#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -x .fvm/flutter_sdk/bin/flutter ]]; then
  FLUTTER=(.fvm/flutter_sdk/bin/flutter)
elif command -v fvm >/dev/null 2>&1; then
  FLUTTER=(fvm flutter)
else
  FLUTTER=(flutter)
fi

find_browser() {
  if [[ -n "${CHROME_BINARY:-}" && -x "${CHROME_BINARY}" ]]; then
    printf '%s\n' "$CHROME_BINARY"
    return
  fi

  for candidate in google-chrome-stable google-chrome chromium chromium-browser; do
    if command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return
    fi
  done

  return 1
}

find_driver() {
  if [[ -n "${CHROMEDRIVER_BINARY:-}" && -x "${CHROMEDRIVER_BINARY}" ]]; then
    printf '%s\n' "$CHROMEDRIVER_BINARY"
    return
  fi

  command -v chromedriver
}

chrome_binary="$(find_browser || true)"
chromedriver_binary="$(find_driver || true)"

chrome_major=""
driver_major=""
if [[ -n "$chrome_binary" ]]; then
  chrome_major="$("$chrome_binary" --version | grep -oE '[0-9]+' | head -1)"
fi
if [[ -n "$chromedriver_binary" ]]; then
  driver_major="$("$chromedriver_binary" --version | grep -oE '[0-9]+' | head -1)"
fi

if [[ -z "$chrome_binary" || -z "$chromedriver_binary" || "$chrome_major" != "$driver_major" ]]; then
  cache_dir="${BROWSER_TESTING_CACHE:-$PWD/.dart_tool/browser-testing}"
  mkdir -p "$cache_dir"
  chrome_binary="$(
    npx -y @puppeteer/browsers@3.2.1 install chrome@stable \
      --path "$cache_dir" --format '{{path}}' | tail -1
  )"
  chromedriver_binary="$(
    npx -y @puppeteer/browsers@3.2.1 install chromedriver@stable \
      --path "$cache_dir" --format '{{path}}' | tail -1
  )"
fi

mkdir -p build
"$chromedriver_binary" --port=4444 >build/chromedriver.log 2>&1 &
chromedriver_pid=$!
cleanup() {
  kill "$chromedriver_pid" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in {1..50}; do
  if curl --silent --fail http://127.0.0.1:4444/status >/dev/null; then
    break
  fi
  sleep 0.1
done
curl --silent --fail http://127.0.0.1:4444/status >/dev/null

"${FLUTTER[@]}" drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/authentication_smoke_test.dart \
  --device-id=web-server \
  --browser-name=chrome \
  --chrome-binary="$chrome_binary" \
  --driver-port=4444 \
  --headless \
  --no-pub \
  --no-web-resources-cdn \
  --dart-define=USE_FIREBASE_EMULATOR=true \
  --timeout=180
