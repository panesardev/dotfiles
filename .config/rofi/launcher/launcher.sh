#!/bin/bash

# manually add websites here alphabetically
websites=(
  "chatgpt.com"
  "claude.ai/new"
  "console.firebase.google.com"
  "drive.google.com"
  "fontawesome.com/search"
  "fonts.google.com"
  "github.com"
  "gmail.com"  
  "keep.google.com"
  "music.youtube.com"
  "nerdfonts.com/cheat-sheet"
  "vercel.com"
  "youtube.com"
)

# show a combined list of desktop apps and webistes in rofi dmenu
chosen=$(
  {
    printf "%s\n" "${websites[@]}"
    grep -rh --include="*.desktop" "^Name=" /usr/share/applications /usr/local/share/applications ~/.local/share/applications 2>/dev/null | cut -d= -f2-
  } | 
  sort -fu |
  rofi -dmenu -i -p ""
)

# exit if nothing selected
[[ -z "$chosen" ]] && exit 0 

# if input is an url, open website
if [[ "$chosen" == *.* ]]; then
  google-chrome-stable "$chosen"
  exit 0
fi

# take out exec command from selected app
command=$(
  grep -rl "^Name=$chosen$" /usr/share/applications /usr/local/share/applications 2>/dev/null | 
  head -1 | 
  xargs grep -m1 "^Exec=" | 
  cut -d= -f2- | 
  sed 's/ *%[a-zA-Z]//g'
)

# if no exec command found, its a search term so perform a google search
if [[ -z "$command" ]]; then
  search=$(printf "%s%%20" "$chosen")
  search=${search:0:-3} # Remove the trailing %20

  google-chrome-stable "https://www.google.com/search?q=$search"
  exit 0
fi

setsid bash -c "$command" &>/dev/null &
disown
