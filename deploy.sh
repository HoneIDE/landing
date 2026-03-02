#!/usr/bin/env bash
set -euo pipefail

HOST="root@webserver.skelpo.net"
REMOTE="/var/www/hone.codes"
FILES=(index.html og-image.png)

# Regenerate og-image.png from svg if svg is newer
if [ og-image.svg -nt og-image.png ]; then
  echo "og-image.svg has changed, regenerating og-image.png..."
  rsvg-convert -w 1200 -h 630 og-image.svg -o og-image.png
fi

# Verify all files exist
for f in "${FILES[@]}"; do
  if [ ! -f "$f" ]; then
    echo "error: $f not found" >&2
    exit 1
  fi
done

echo "Deploying to $HOST:$REMOTE ..."
scp "${FILES[@]}" "$HOST:$REMOTE/"
echo "Done → https://hone.codes"
