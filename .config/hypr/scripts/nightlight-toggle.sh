#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   nightlight-toggle.sh — Toggle warm color temperature
#   Reads actual current temperature from hyprctl (no state file).
#   Bound to Super+Shift+N and Super+F7 by default.
# ══════════════════════════════════════════════════════════════════

ON_TEMP=4000
OFF_TEMP=6500

# Ensure hyprsunset is running
if ! pgrep -x hyprsunset >/dev/null; then
  hyprsunset -t $OFF_TEMP &disown
  sleep 0.5
fi

# Query the real current temperature from hyprctl
CURRENT_TEMP=$(hyprctl hyprsunset temperature 2>/dev/null | grep -oE '[0-9]+' | head -1)

# Fallback: if hyprctl query fails, read from state file
if [[ -z "$CURRENT_TEMP" ]]; then
  CURRENT_TEMP=$(cat "$HOME/.config/hypr/.nightlight_temp" 2>/dev/null || echo "$OFF_TEMP")
fi

if (( CURRENT_TEMP <= ON_TEMP )); then
  # Currently warm → switch to daylight
  hyprctl hyprsunset temperature $OFF_TEMP 2>/dev/null || hyprsunset -t $OFF_TEMP &disown
  echo "$OFF_TEMP" > "$HOME/.config/hypr/.nightlight_temp"
  notify-send -u low "   Night light OFF" "${OFF_TEMP}K — daylight"
else
  # Currently cool → switch to warm
  hyprctl hyprsunset temperature $ON_TEMP 2>/dev/null || hyprsunset -t $ON_TEMP &disown
  echo "$ON_TEMP" > "$HOME/.config/hypr/.nightlight_temp"
  notify-send -u low "  Night light ON" "${ON_TEMP}K — warm"
fi

# Signal waybar to refresh nightlight module if present
pkill -RTMIN+12 waybar 2>/dev/null || true
