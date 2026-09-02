#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

npm ci --prefix firebase-tests --ignore-scripts
npx -y firebase-tools@15.28.2 emulators:exec \
  --project demo-forge-dance \
  --only firestore \
  "npm test --prefix firebase-tests"
