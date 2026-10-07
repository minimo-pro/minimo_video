#!/usr/bin/env bash
# Export all project locales; requires the dev server, Chrome, Playwright and Pillow.
set -euo pipefail
cd "$(dirname "$0")/.."
exec python3 scripts/export-locales.py "$@"
