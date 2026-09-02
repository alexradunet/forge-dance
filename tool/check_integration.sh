#!/usr/bin/env bash
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

"${FLUTTER[@]}" pub get
"${DART[@]}" run easy_localization:generate \
  -f keys \
  -o locale_keys.g.dart \
  --source-dir assets/translations
"${DART[@]}" run build_runner build

npx -y firebase-tools@15.28.2 emulators:exec \
  --project forgedance-52c54 \
  --only auth,firestore \
  "bash tool/run_web_integration.sh"
