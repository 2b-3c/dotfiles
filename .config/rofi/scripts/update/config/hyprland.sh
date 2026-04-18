#!/usr/bin/env bash
cp -f "$HOME/dotfiles/.config/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
hyprctl reload
notify-send "Hyprland" "✓ Default settings reapplied"
