#!/usr/bin/env bash
set -euo pipefail

HOST="root@webserver.skelpo.net"
REMOTE="/var/www/hone.codes"
ROOT_FILES=(index.html style.css og-image.png screenshot.png)
LANGS=(de ja zh-Hans es fr pt ko it tr th id vi)

# Regenerate og-image.png from svg if svg is newer
if [ og-image.svg -nt og-image.png ]; then
  echo "og-image.svg has changed, regenerating og-image.png..."
  rsvg-convert -w 1200 -h 630 og-image.svg -o og-image.png
fi

# Verify root files exist
for f in "${ROOT_FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "error: $f not found" >&2
    exit 1
  fi
done

echo "Deploying to $HOST:$REMOTE ..."

# Deploy root files
scp "${ROOT_FILES[@]}" "$HOST:$REMOTE/"

# Deploy locale directories
for lang in "${LANGS[@]}"; do
  if [ ! -f "$lang/index.html" ]; then
    echo "error: $lang/index.html not found" >&2
    exit 1
  fi
  ssh "$HOST" "mkdir -p $REMOTE/$lang"
  scp "$lang/index.html" "$HOST:$REMOTE/$lang/"
done

echo "Done → https://hone.codes"
