#!/bin/bash
SPRITES=(
  "./renders/poofs.png"
  "./renders/airflowing.png"
  "./renders/glass_breaking.png"
)

LAST_Y=0

# First arg is the sprite
# Second is the comma or blank
function json_entry {
  W=`convert $1 -format "%w" info:`
  H=`convert $1 -format "%h" info:`

  SIZE="\"x\": 0, \"y\": $LAST_Y, \"w\": $W, \"h\": $H"

  IMAGE_NAME=`basename $1 .png`
  LAST_Y="$(($LAST_Y + $H))"
}

rm -f ./poofs.png

cp "${SPRITES[0]}" ./poofs.png
json_entry "${SPRITES[0]}" ","

for SPRITE in ${SPRITES[@]:1}; do
  COMMA=$([ "$SPRITE" == "${SPRITES[${#SPRITES[@]}-1]}" ] && echo "" || echo ",")

  json_entry $SPRITE $COMMA
  convert ./poofs.png $SPRITE -append -transparent white ./poofs.png
done

convert ./poofs.png -transparent white ./poofs.png
