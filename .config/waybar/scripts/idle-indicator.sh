#!/bin/bash
# Waybar indicator: shows 󱫖 icon when hypridle (auto-lock) is disabled.

if pgrep -x hypridle >/dev/null; then
  echo '{"text": ""}'
else
  echo '{"text": "󱫖", "tooltip": "Auto-lock disabled", "class": "active"}'
fi
