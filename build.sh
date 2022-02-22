#!/usr/bin/env bash
# Copyright (c) 2013 Gordon Williams, Pur3 Ltd. See the file LICENSE for copying permission.

set -e

cd `dirname $0`
BUILDARGS=$1

DIR=`pwd`
WEBSITE=~/workspace/espruinowebsite
rm -rf "$WEBSITE"
rm -f html/*.html
rm -f html/*.js
rm -f html/refimages/*
rm -f html/boards/*
mkdir -p "$WEBSITE" "$WEBSITE/www/img" "$WEBSITE/www/scripts"
mkdir -p "$WEBSITE/reference" "$WEBSITE/www/js" "$WEBSITE/www/datasheets"
mkdir -p "$WEBSITE/www/files" "$WEBSITE/www/refimages"
mkdir -p html/refimages
mkdir -p html/boards
mkdir -p html/img

node bin/commenter.js

cd ../Espruino

for BOARDNAME in PICO_R1_3 ESPRUINOBOARD ESP8266_BOARD EMW3165 MICROBIT2 ESPRUINOWIFI PUCKJS PIXLJS ESP32 WIO_LTE MDBT42Q THINGY52 NRF52832DK STM32L496GDISCOVERY RAK8211 RAK8212 RAK5010
do
  python scripts/build_board_docs.py $BOARDNAME pinout || true
  mv boards/$BOARDNAME.html "$DIR/html/boards"
  cp boards/img/$BOARDNAME.* "$WEBSITE/www/img" 2>/dev/null || true
  cp boards/img/$BOARDNAME.* "$DIR/html/img" 2>/dev/null || true
done

cd "$DIR"

echo "Getting file modification times..."
git ls-tree -r --name-only HEAD | xargs -I{} git log -1 --format="%at {}" -- {} | sort > ordering.txt
# Push these items to the front
echo "2000000000 tutorials/Bangle.js Getting Started.md" >> ordering.txt
echo "2000000000 tutorials/Bangle.js Development.md" >> ordering.txt
# Built reference docs and references.json
node --trace-deprecation bin/build.js $BUILDARGS

cp html/*.html "$WEBSITE/reference/"
cp html/keywords.js "$WEBSITE/www/js/"
cp datasheets/* "$WEBSITE/www/datasheets/"
cp files/* "$WEBSITE/www/files/"
cp html/refimages/* "$WEBSITE/www/refimages/"
# Resize any images that might be too big, and remove metadata
#mogrify -resize "600x800>" -strip $WEBSITE/www/refimages/*

# -----------------------------------
bash buildmodules.sh
