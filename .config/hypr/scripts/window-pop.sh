#!/usr/bin/env bash
# Float and pin the active window (pop it out of tiling)
FLOATING=$(hyprctl activewindow -j | jq -r '.floating')
if [[ "$FLOATING" == "true" ]]; then
    hyprctl dispatch togglefloating active
    hyprctl dispatch pin active
else
    hyprctl dispatch togglefloating active
    hyprctl dispatch pin active
    hyprctl dispatch resizeactive exact 900 600
    hyprctl dispatch centerwindow
fi
