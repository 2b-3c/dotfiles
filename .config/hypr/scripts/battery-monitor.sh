#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   battery-monitor.sh — ONYX Battery Monitor
#   Run every 30 seconds by systemd timer.
#   Sends a critical notification when battery is critically low.
# ══════════════════════════════════════════════════════════════════

BATTERY_THRESHOLD=10
NOTIFICATION_FLAG="/run/user/$UID/onyx_battery_notified"

BAT_PATH=$(upower -e | grep -i 'BAT' | head -1)
[[ -z "$BAT_PATH" ]] && exit 0   # no battery → desktop machine

BATTERY_LEVEL=$(upower -i "$BAT_PATH" | awk '/percentage/ { gsub(/%/,""); print int($2); exit }')
BATTERY_STATE=$(upower -i "$BAT_PATH" | awk '/state/ { print $2; exit }')

send_notification() {
  notify-send -u critical "󱐋 Time to recharge!" \
    "Battery is down to ${1}%" \
    -i battery-caution -t 30000
  # Run hook if it exists
  HOOK="$HOME/.config/onyx/hooks/battery-low"
  [[ -f "$HOOK" ]] && bash "$HOOK" "$1"
}

if [[ -n "$BATTERY_LEVEL" && "$BATTERY_LEVEL" =~ ^[0-9]+$ ]]; then
  if [[ "$BATTERY_STATE" == "discharging" ]] && (( BATTERY_LEVEL <= BATTERY_THRESHOLD )); then
    if [[ ! -f "$NOTIFICATION_FLAG" ]]; then
      send_notification "$BATTERY_LEVEL"
      touch "$NOTIFICATION_FLAG"
    fi
  else
    rm -f "$NOTIFICATION_FLAG"
  fi
fi
