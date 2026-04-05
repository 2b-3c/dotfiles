#!/usr/bin/env bash
cp -f "$HOME/dotfiles/.config/waybar/config.jsonc" "$HOME/.config/waybar/config.jsonc"
pkill waybar; waybar &
notify-send "Waybar" "✓ Settings reapplied and restarted"
