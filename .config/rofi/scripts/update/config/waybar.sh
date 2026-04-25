#!/usr/bin/env bash
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
SRC="$DOTFILES/.config/waybar/config.jsonc"

if [[ ! -f "$SRC" ]]; then
    notify-send -u critical "Waybar" "Dotfiles not found at $DOTFILES"
    exit 1
fi

cp -f "$SRC" "$HOME/.config/waybar/config.jsonc"
pkill waybar 2>/dev/null
sleep 0.5
waybar &disown
notify-send "Waybar" "✓ Settings reapplied and restarted"
