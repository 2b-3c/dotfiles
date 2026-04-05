#!/bin/bash

# Toggle night light (warm color temperature) using hyprsunset directly.
# Replaces systemd service approach with direct hyprctl hyprsunset commands.

ON_TEMP=4000
OFF_TEMP=6000

# Ensure hyprsunset is running
if ! pgrep -x hyprsunset; then
  hyprsunset &
  sleep 1
fi

CURRENT_TEMP=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+')

if [[ $CURRENT_TEMP == $OFF_TEMP ]]; then
  hyprctl hyprsunset temperature $ON_TEMP
  notify-send -u low "  Night light ON (${ON_TEMP}K)"
else
  hyprctl hyprsunset temperature $OFF_TEMP
  notify-send -u low "   Night light OFF (${OFF_TEMP}K)"
fi

# Restart waybar if it has a nightlight/hyprsunset module
if grep -q "hyprsunset\|nightlight" ~/.config/waybar/config.jsonc 2>/dev/null; then
  pkill -SIGUSR2 waybar 2>/dev/null || (pkill waybar; waybar &)
fi
