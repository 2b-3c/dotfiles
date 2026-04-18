#!/usr/bin/env bash
# Toggle single-window master ratio between 50% and 65%
CURRENT=$(hyprctl getoption master:mfact | awk '/float/{print $2}')
if [ "$CURRENT" = "0.5" ] || [ "$CURRENT" = "0.500000" ]; then
    hyprctl keyword master:mfact 0.65
    notify-send -u low "1-Window Ratio" "Ratio 65%"
else
    hyprctl keyword master:mfact 0.5
    notify-send -u low "1-Window Ratio" "Ratio 50% (square)"
fi
