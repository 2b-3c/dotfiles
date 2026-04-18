#!/usr/bin/env bash
cp -f "$HOME/dotfiles/.config/hypr/hypridle.conf" "$HOME/.config/hypr/hypridle.conf"
systemctl --user restart hypridle
notify-send "Hypridle" "✓ Settings reapplied and restarted"
