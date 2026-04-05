#!/usr/bin/env bash
# Toggle Waybar visibility
if pgrep -x waybar > /dev/null; then
    pkill waybar
    notify-send -u low "Top Bar" "Waybar hidden"
else
    waybar &
    notify-send -u low "Top Bar" "Waybar shown"
fi
