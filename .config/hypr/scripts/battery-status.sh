#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   battery-status.sh — Detailed battery status notification
#   Bind to a key to see full battery info at a glance.
# ══════════════════════════════════════════════════════════════════

BAT_PATH=$(upower -e | grep -i 'BAT' | head -1)
[[ -z "$BAT_PATH" ]] && { notify-send "No battery detected" -u low; exit 0; }

battery_info=$(upower -i "$BAT_PATH")

percentage=$(echo "$battery_info" | awk '/percentage/ { gsub(/%/,""); print int($2); exit }')
power_rate=$(echo "$battery_info" | awk '/energy-rate/ { printf "%.1f", $2; exit }' | sed 's/\.0$//')
state=$(echo "$battery_info" | awk '/state/ { print $2; exit }')
capacity=$(echo "$battery_info" | awk '/capacity/ { gsub(/%/,""); print int($2); exit }')

# Time remaining
time_line=$(echo "$battery_info" | grep -E "time to (full|empty)")
if [[ -n "$time_line" ]]; then
  time_remaining=$(echo "$time_line" | awk '{print $4, $5}')
else
  time_remaining="calculating..."
fi

if [[ "$state" == "charging" ]]; then
  msg="󰁹  ${percentage}%  ·  ${time_remaining} to full  ·  ${power_rate}W  ·  Health ${capacity}%"
else
  msg="󰁹  ${percentage}%  ·  ${time_remaining} left  ·  ${power_rate}W draw  ·  Health ${capacity}%"
fi

notify-send "Battery Status" "$msg" -u low -t 6000
