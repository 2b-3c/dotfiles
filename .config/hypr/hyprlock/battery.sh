#!/bin/bash

battery_percentage=$(cat /sys/class/power_supply/BAT0/capacity)
battery_status=$(cat /sys/class/power_supply/BAT0/status)

if [ "$battery_status" = "Charging" ]; then
    echo "󰂄 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 90 ]; then
    echo "󰁹 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 80 ]; then
    echo "󰂂 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 70 ]; then
    echo "󰂁 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 60 ]; then
    echo "󰂀 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 50 ]; then
    echo "󰁿 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 40 ]; then
    echo "󰁾 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 30 ]; then
    echo "󰁽 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 20 ]; then
    echo "󰁼 ${battery_percentage}%"
elif [ "$battery_percentage" -ge 10 ]; then
    echo "󰁻 ${battery_percentage}%"
else
    echo "󰁺 ${battery_percentage}%"
fi
