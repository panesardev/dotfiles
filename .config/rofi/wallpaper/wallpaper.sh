#!/usr/bin/env bash

# keep all wallpapers here
WALLPAPER_DIR="$HOME/Pictures/Wallpapers"

# save current directory for later
CMD=$(pwd)

# cd into wallapers directory. if fails, exit with code 1
cd "$WALLPAPER_DIR" || exit 1

# loop over all wallapers and select wallpaper from list in rofi menu
IMAGE=$(for a in *; do echo -en "$a\0icon\x1f$a\n"; done | rofi -dmenu -p "" -i -show-icons)

# if selected
if [ -n "$IMAGE" ]; then

  OUTPUT=$(
    # magick "$IMAGE" -colors 4 -format "%c" histogram:info:- | 
    # grep -Eo '#[0-9A-F]{6}' | 
    python3 ~/.config/rofi/wallpaper/generate-colors.py "$IMAGE" |
    while read -r line; do echo -en "<span foreground='$line' background='$line'>  </span> $line\n"; done | 
    rofi -dmenu -markup-rows -theme ~/.config/rofi/wallpaper/wallpaper.rasi -theme-str 'inputbar { enabled: false; }'
  )

  HEX="${OUTPUT: -7}"

  # matugen colors 
  matugen color hex "$HEX" --source-color-index 0 -q

  # set wallpaper
  awww img "$IMAGE" --transition-type="center" --transition-duration="1" --transition-fps="60"

fi

# go back to original directory
cd "$CMD"

