#!/usr/bin/env bash
cp -f "$HOME/dotfiles/.config/hypr/hyprlock.conf" "$HOME/.config/hypr/hyprlock.conf"
notify-send "Hyprlock" "✓ Settings reapplied"
