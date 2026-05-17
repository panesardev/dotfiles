#!/usr/bin/env bash

# THEME="$HOME/.config/rofi/theme.rasi"
THEME="$HOME/.config/rofi/powermenu/powermenu.rasi"

LOCK=" Lock"
SUSPEND=" Suspend"
HIBERNATE=" Hibernate"
LOGOUT=" Logout"
REBOOT=" Reboot"
SHUTDOWN=" Shutdown"
 
chosen=$(printf '%s\n' \
  "$LOCK" \
  "$SUSPEND" \
  "$HIBERNATE" \
  "$LOGOUT" \
  "$REBOOT" \
  "$SHUTDOWN" \
  | rofi -dmenu -theme "$THEME")
 
case "$chosen" in
  "$LOCK")      loginctl lock-session ;;
  "$SUSPEND")   systemctl suspend ;;
  "$HIBERNATE") systemctl hibernate ;;
  "$LOGOUT")    hyprctl dispatch exit 0 ;;
  "$REBOOT")    systemctl reboot ;;
  "$SHUTDOWN")  systemctl poweroff ;;
esac
 