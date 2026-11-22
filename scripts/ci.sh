#!/usr/bin/env bash
set -euo pipefail

npm ci
npm run build
npm test

if [[ ! -f dist/hello.js ]]; then
  echo "Expected dist/hello.js after build" >&2
  exit 1
fi

node dist/hello.js
