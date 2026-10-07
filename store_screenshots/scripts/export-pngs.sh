#!/usr/bin/env bash
# Renders every slide of the saved deck at native store resolution into ./export.
# Requires the dev server (npm run dev) on $BASE and Google Chrome.
set -euo pipefail
cd "$(dirname "$0")/.."

BASE="${BASE:-http://localhost:3000}"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"
OUT="export"

shoot() { # device w h index file
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size="$2,$3" --virtual-time-budget=15000 \
    --screenshot="$5" "$BASE/preview?device=$1&bare&from=$4&n=1" 2>/dev/null
}

count() {
  node -e "const s=require('./app-store-screenshots.json');const st=s.state??s;console.log((st.slidesByDevice['$1']||[]).length)"
}

creative() { # kind w h file
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size="$2,$3" --virtual-time-budget=15000 \
    --screenshot="$4" "$BASE/creative?kind=$1" 2>/dev/null
}

for spec in "header:3840:1646:apple/header" "search:3840:2560:apple/search-results" "play:1024:500:android/feature-graphic"; do
  IFS=: read -r kind w h dir <<<"$spec"
  mkdir -p "$OUT/$dir"
  creative "$kind" "$w" "$h" "$OUT/$dir/01.png"
  echo "$OUT/$dir/01.png"
done

for spec in "iphone:1320:2868:apple/iphone-6.9" "ipad:2064:2752:apple/ipad-13" "android:1080:1920:android/phone"; do
  IFS=: read -r device w h dir <<<"$spec"
  mkdir -p "$OUT/$dir"
  n=$(count "$device")
  for ((i = 0; i < n; i++)); do
    file="$OUT/$dir/$(printf '%02d' $((i + 1))).png"
    shoot "$device" "$w" "$h" "$i" "$file"
    echo "$file"
  done
done

# App Store Connect rejects screenshots with an alpha channel.
python3 - <<'PY'
import glob
from PIL import Image
for f in glob.glob("export/**/*.png", recursive=True):
    im = Image.open(f)
    if im.mode != "RGB":
        im.convert("RGB").save(f)
PY
