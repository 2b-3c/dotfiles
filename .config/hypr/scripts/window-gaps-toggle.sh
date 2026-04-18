#!/usr/bin/env bash
# Toggle window gaps on/off
GAPS=$(hyprctl getoption general:gaps_out -j | jq -r '.int')
if [[ "$GAPS" -gt 0 ]]; then
    hyprctl keyword general:gaps_in 0
    hyprctl keyword general:gaps_out 0
else
    hyprctl keyword general:gaps_in 5
    hyprctl keyword general:gaps_out 10
fi
