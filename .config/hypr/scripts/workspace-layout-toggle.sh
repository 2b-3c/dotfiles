#!/usr/bin/env bash
# Toggle workspace layout between dwindle and master
CURRENT=$(hyprctl activeworkspace -j | jq -r '.layout // "dwindle"')
if [[ "$CURRENT" == "dwindle" ]]; then
    hyprctl keyword general:layout master
else
    hyprctl keyword general:layout dwindle
fi
