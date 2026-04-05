#!/usr/bin/env bash
# Toggle transparency on the active window
ADDRESS=$(hyprctl activewindow -j | jq -r '.address')
OPACITY=$(hyprctl activewindow -j | jq -r '.opacityConfig // 1')
if [[ "$OPACITY" == "1" ]]; then
    hyprctl setprop address:"$ADDRESS" alpha 0.85
else
    hyprctl setprop address:"$ADDRESS" alpha 1
fi
