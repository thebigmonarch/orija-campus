#!/usr/bin/env bash
# Vercel build: compile the Orija Campus web app from the code FlutterFlow
# pushes to the `flutterflow` branch, and put it in ./public next to the
# share-link router (api/go.js). The router and this script live on `main`,
# because FlutterFlow may overwrite anything on its own branch.
#
# Optional Vercel environment variables:
#   APP_BRANCH       branch FlutterFlow pushes to (default: flutterflow)
#   FLUTTER_VERSION  Flutter branch or tag (default: stable, what FlutterFlow uses)
#   GITHUB_TOKEN     only needed if the repo is private
set -euo pipefail

APP_BRANCH="${APP_BRANCH:-flutterflow}"
FLUTTER_REF="${FLUTTER_VERSION:-stable}"
REPO="${REPO:-thebigmonarch/orija-campus}"
ROOT="$(pwd)"

if [ -n "${GITHUB_TOKEN:-}" ]; then
  REPO_URL="https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO}.git"
else
  REPO_URL="https://github.com/${REPO}.git"
fi

rm -rf .build && mkdir -p .build && cd .build

echo "==> Flutter (${FLUTTER_REF})"
git clone --quiet --depth 1 -b "${FLUTTER_REF}" https://github.com/flutter/flutter.git flutter
export PATH="$PWD/flutter/bin:$PATH"
flutter config --no-analytics --enable-web >/dev/null
flutter --version

echo "==> App code (${APP_BRANCH})"
git clone --quiet --depth 1 -b "${APP_BRANCH}" "${REPO_URL}" app
cd app
git log --oneline -1

echo "==> Build"
flutter pub get
# FlutterFlow apps use custom icon fonts that icon tree-shaking can't follow.
flutter build web --release --no-tree-shake-icons --base-href /

rm -rf "${ROOT}/public"
cp -r build/web "${ROOT}/public"
echo "==> Done: $(du -sh "${ROOT}/public" | cut -f1) in public/"
