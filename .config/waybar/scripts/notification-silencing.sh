#!/bin/bash
# Waybar indicator: shows 󰂛 icon when swaync is in Do Not Disturb mode.

DND_STATUS=$(swaync-client -D 2>/dev/null)
if [[ "$DND_STATUS" == "true" ]]; then
  echo '{"text": "󰂛", "tooltip": "Do Not Disturb active", "class": "active"}'
else
  echo '{"text": ""}'
fi
