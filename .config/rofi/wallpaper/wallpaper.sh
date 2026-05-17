#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
THEME="$HOME/.config/rofi/wallpaper/wallpaper.rasi"

cd "$WALLPAPER_DIR" || { notify-send "ERROR" "$WALLPAPER_DIR doesn't exist"; exit 1; }

# loop over all wallapers and select wallpaper from list via rofi menu
IMAGE=$(
  for a in *; do echo -en "$a\0icon\x1f$a\n"; done | 
  rofi -dmenu -i -p ""
)

# exit if image not selected
if [ -z $IMAGE ]; then
  exit 1
fi

# generate and select hex color from wallpaper
HEX=$(
  python3 ~/.config/rofi/wallpaper/generate-colors.py "$IMAGE" |
  while read -r line; do echo -en "<span foreground='$line' background='$line'>  </span> $line\n"; done | 
  rofi -dmenu -markup-rows -i -p "" |
  tail -c 8 # last 7 characters
)

# matugen colors 
matugen color hex "$HEX" --source-color-index 0 --mode dark

# set wallpaper
awww img "$IMAGE" --transition-type="any" --transition-duration="1" --transition-fps="60"
