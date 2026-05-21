#!/bin/bash

wallpaper_dir="$HOME/Pictures/Wallpapers"

cd "$wallpaper_dir" || { notify-send "ERROR" "$wallpaper_dir doesn't exist"; exit 1; }

# loop over all wallapers and select wallpaper from list via rofi menu
image=$(
  for a in *; do echo -en "$a\0icon\x1f$a\n"; done | 
  rofi -dmenu -i -p "" -show-icons
)
[[ -z "$image" ]] && exit 1

mode=$(
  printf "dark\nlight\n" |
  rofi -dmenu -i -p "" -theme-str 'window { width: 200px; } inputbar { enabled: false; }'
)
[[ -z "$mode" ]] && exit 1

# generate and select hex color from wallpaper
hex=$(
  python3 ~/.config/rofi/wallpaper/generate-colors.py "$image" |
  while read -r line; do echo -en "<span foreground='$line' background='$line'>  </span> $line\n"; done | 
  rofi -dmenu -markup-rows -i -p "" -theme-str 'window { width: 200px; } inputbar { enabled: false; }' |
  tail -c 8 # last 7 characters
)
[[ -z "$hex" ]] && exit 1

# generate material you colors 
matugen color hex "$hex" --source-color-index 0 --mode "$mode"

# set wallpaper
awww img "$image" --transition-type="any" --transition-duration="1" --transition-fps="60"
