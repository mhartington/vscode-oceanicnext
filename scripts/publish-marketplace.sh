#!/usr/bin/env bash
set -euo pipefail

RELEASE_TYPE="${1:-patch}"

if [[ -z "${VSCE_PAT:-}" ]]; then
  echo "Error: VSCE_PAT is not set."
  echo "Create a Marketplace PAT and export it first:"
  echo "  export VSCE_PAT=your_token_here"
  exit 1
fi

if ! command -v npx >/dev/null 2>&1; then
  echo "Error: npx is required (install Node.js/npm first)."
  exit 1
fi

if [[ ! -f "package.json" ]]; then
  echo "Error: package.json not found. Run this from the project root."
  exit 1
fi

if [[ "${RELEASE_TYPE}" != "patch" && "${RELEASE_TYPE}" != "minor" && "${RELEASE_TYPE}" != "major" ]]; then
  echo "Error: release type must be one of: patch, minor, major"
  echo "Usage: ./scripts/publish-marketplace.sh [patch|minor|major]"
  exit 1
fi

PUBLISHER="$(node -p "require('./package.json').publisher")"

if [[ -z "${PUBLISHER}" || "${PUBLISHER}" == "undefined" ]]; then
  echo "Error: publisher is missing in package.json"
  exit 1
fi

echo "Publishing ${PUBLISHER}/${RELEASE_TYPE} release to VS Code Marketplace..."
npx --yes @vscode/vsce publish "${RELEASE_TYPE}" --pat "${VSCE_PAT}"
echo "Publish complete."
