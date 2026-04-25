#!/bin/bash
# Waybar indicator: shows 󰻂 icon while screen recording is active.
# Add to waybar config as custom/screenrecord with "exec" pointing here.

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
  echo '{"text": "󰻂", "tooltip": "Recording — click to stop", "class": "active"}'
else
  echo '{"text": ""}'
fi
