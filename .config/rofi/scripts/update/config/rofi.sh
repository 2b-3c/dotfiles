#!/usr/bin/env bash
cp -rf "${DOTFILES:-$HOME/dotfiles}/.config/rofi/." "$HOME/.config/rofi/"
notify-send "rofi" "✓ rofi settings reapplied"
