#!/bin/bash

if [[ "$1" == "clear" ]]; then
  echo -e "Clear Clipboard\nCancel" | 
  rofi -dmenu -theme-str "inputbar { enabled: false; }" | 
  grep -q "Clear History" && cliphist wipe

  exit
fi

cliphist list |
rofi -dmenu -i | 
cliphist decode | 
wl-copy && wtype -M ctrl -P v -p v -m ctrl # automatic paste
