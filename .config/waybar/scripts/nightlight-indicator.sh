#!/bin/bash
# Waybar indicator: shows  icon when night light (warm temperature) is ON.

CURRENT_TEMP=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+' | head -1)
ON_TEMP=4500  # threshold: anything below this = night light on

if [[ -n "$CURRENT_TEMP" ]] && (( CURRENT_TEMP < ON_TEMP )); then
  echo '{"text": "", "tooltip": "Night light ON", "class": "active"}'
else
  echo '{"text": ""}'
fi
