#!/usr/bin/env bash

# backup.sh — backs up explicitly installed pacman and AUR packages

set -euo pipefail
 
BACKUP_DIR="${1:-$HOME/Projects/dotfiles/.local/backup}"

mkdir -p "$BACKUP_DIR"

BACKUP_FILE="$BACKUP_DIR/packages.txt"
 
{ pacman -Qqen; pacman -Qqem; } > "$BACKUP_FILE"
 
echo ""
echo "Wrote $(wc -l < "$BACKUP_FILE") packages to $BACKUP_FILE"
echo ""
echo "To restore:"
echo "  yay -S --needed - < $BACKUP_FILE"
echo ""

