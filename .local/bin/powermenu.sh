#!/usr/bin/env bash

theme_str='* { font: "FiraCode Nerd Font Mono Regular 12"; } window { width: 200px; } inputbar { enabled: false; }'

lock=" Lock"
sleep=" Sleep"
hibernate=" Hibernate"
logout=" Logout"
reboot=" Reboot"
shutdown=" Shutdown"
 
input=$(printf '%s\n' \
  "$lock" \
  "$sleep" \
  "$hibernate" \
  "$logout" \
  "$reboot" \
  "$shutdown" \
  | rofi -dmenu -theme-str "$theme_str")
 
case "$input" in
  "$lock")      loginctl lock-session ;;
  "$sleep")   systemctl suspend ;;
  "$hibernate") systemctl hibernate ;;
  "$logout")    hyprctl dispatch exit 0 ;;
  "$reboot")    systemctl reboot ;;
  "$shutdown")  systemctl poweroff ;;
esac
 