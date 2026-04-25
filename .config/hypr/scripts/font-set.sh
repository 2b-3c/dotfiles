#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   font-set.sh — Set system-wide monospace font
#   Applies to: Kitty, Hyprlock, Waybar, GTK fontconfig
#   Usage: font-set.sh <font-name>
#   List fonts: font-list.sh
# ══════════════════════════════════════════════════════════════════

font_name="$1"

if [[ -z "$font_name" ]]; then
  echo "Usage: font-set.sh <font-name>"
  echo "List fonts: font-list.sh"
  exit 1
fi

if ! fc-list | grep -iq "$font_name"; then
  notify-send "Font not found" "'$font_name' is not installed" -u critical -t 4000
  echo "Font '$font_name' not found."
  exit 1
fi

# Kitty
if [[ -f ~/.config/kitty/kitty.conf ]]; then
  sed -i "s/^font_family .*/font_family $font_name/g" ~/.config/kitty/kitty.conf
  pkill -USR1 kitty 2>/dev/null || true
fi

# Hyprlock
if [[ -f ~/.config/hypr/hyprlock.conf ]]; then
  sed -i "s/font_family = .*/font_family = $font_name/g" ~/.config/hypr/hyprlock.conf
fi

# Waybar
if [[ -f ~/.config/waybar/style.css ]]; then
  sed -i "s/font-family:.*/font-family: '$font_name', monospace;/g" ~/.config/waybar/style.css
fi

# Fontconfig (GTK + system-wide monospace)
FONTS_CONF="$HOME/.config/fontconfig/fonts.conf"
if [[ -f "$FONTS_CONF" ]] && command -v xmlstarlet &>/dev/null; then
  xmlstarlet ed -L \
    -u '//match[@target="pattern"][test/string="monospace"]/edit[@name="family"]/string' \
    -v "$font_name" \
    "$FONTS_CONF" 2>/dev/null || true
fi

# Restart waybar
pkill waybar 2>/dev/null; sleep 0.4; waybar &disown

notify-send "Font changed" "Now using: $font_name" -u low -t 3000

# Run hook if exists
HOOK="$HOME/.config/onyx/hooks/font-set"
[[ -f "$HOOK" ]] && bash "$HOOK" "$font_name"
