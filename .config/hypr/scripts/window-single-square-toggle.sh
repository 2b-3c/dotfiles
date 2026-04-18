#!/bin/bash

# Toggle single-window square aspect ratio.
# When only one window is open in a workspace, it will be displayed as a centered square.

CURRENT_VALUE=$(hyprctl getoption "layout:single_window_aspect_ratio" 2>/dev/null | head -1)

if [[ $CURRENT_VALUE == *"[1, 1]"* ]]; then
  hyprctl keyword layout:single_window_aspect_ratio "0 0"
  notify-send -u low "    Single-window square aspect: OFF"
else
  hyprctl keyword layout:single_window_aspect_ratio "1 1"
  notify-send -u low "    Single-window square aspect: ON"
fi
