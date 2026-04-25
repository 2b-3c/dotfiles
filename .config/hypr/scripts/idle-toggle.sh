#!/usr/bin/env bash
# Toggle hypridle (auto screen lock)
if pgrep -x hypridle > /dev/null; then
    pkill hypridle
    notify-send -u low "Idle Lock" "Auto-lock disabled"
else
    hypridle &
    notify-send -u low "Idle Lock" "Auto-lock enabled"
fi
