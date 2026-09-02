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

  if [[ -n "${CHROME_PATH:-}" && -x "${CHROME_PATH}" ]]; then
    printf '%s\n' "$CHROME_PATH"
    return
  fi

  for candidate in google-chrome-stable google-chrome chromium chromium-browser; do
    if command -v "$candidate" >/dev/null 2>&1; then
      command -v "$candidate"
      return
    fi
  done

  if [[ "$(uname -s)" == "Darwin" ]]; then
    local macos_chrome="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    if [[ -x "$macos_chrome" ]]; then
      printf '%s\n' "$macos_chrome"
      return
    fi
  fi

  return 1
}

browser_path="$(find_browser || true)"
if [[ -z "$browser_path" ]]; then
  cache_dir="${BROWSER_TESTING_CACHE:-$PWD/.dart_tool/browser-testing}"
  mkdir -p "$cache_dir"
  browser_path="$(
    npx -y @puppeteer/browsers@3.2.1 install chrome@stable \
      --path "$cache_dir" --format '{{path}}' | tail -1
  )"
fi

port="${WEB_QUALITY_PORT:-7358}"
report_dir="$PWD/build/lighthouse"
report_base="$report_dir/forge-dance"
report_json="$report_base.report.json"
rm -rf "$report_dir"
mkdir -p "$report_dir"

if [[ "${SKIP_WEB_BUILD:-false}" == "true" ]]; then
  if [[ ! -f build/web/index.html ]]; then
    printf 'SKIP_WEB_BUILD=true requires an existing build/web/index.html\n' >&2
    exit 1
  fi
else
  build_args=(
    web
    --release
    --no-pub
    --no-web-resources-cdn
    --dart-define=USE_FIREBASE_EMULATOR=true
  )
  if [[ "${WEB_BUILD_WASM:-true}" == "true" ]]; then
    build_args+=(--wasm)
  fi
  "${FLUTTER[@]}" build "${build_args[@]}"
fi

python3 -m http.server "$port" \
  --bind 127.0.0.1 \
  --directory build/web \
  >"$report_dir/server.log" 2>&1 &
server_pid=$!
cleanup() {
  kill "$server_pid" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in {1..100}; do
  if ! kill -0 "$server_pid" >/dev/null 2>&1; then
    printf 'Web server exited before becoming ready:\n' >&2
    cat "$report_dir/server.log" >&2
    exit 1
  fi
  if curl --silent --fail "http://127.0.0.1:$port/" >/dev/null; then
    break
  fi
  sleep 0.1
done
curl --silent --fail "http://127.0.0.1:$port/" >/dev/null

CHROME_PATH="$browser_path" npx -y lighthouse@13.4.1 \
  "http://127.0.0.1:$port/" \
  --only-categories=performance,accessibility,best-practices,seo \
  --output=json \
  --output=html \
  --output-path="$report_base" \
  --chrome-flags="--headless=new --no-sandbox --disable-dev-shm-usage" \
  --max-wait-for-load=60000 \
  --quiet \
  --disable-full-page-screenshot \
  --no-enable-error-reporting

node tool/verify_lighthouse.mjs "$report_json"
printf 'Reports: %s.report.{json,html}\n' "$report_base"
