#!/bin/bash

# Switch between available audio output sinks, preserving mute status.
# Bound to Super+XF86AudioMute by default.

focused_monitor="$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"

sinks=$(pactl -f json list sinks | jq '[.[] | select((.ports | length == 0) or ([.ports[]? | .availability != "not available"] | any))]')
sinks_count=$(echo "$sinks" | jq '. | length')

if (( sinks_count == 0 )); then
  notify-send "No audio devices found" -u critical -t 3000
  exit 1
fi

current_sink_name=$(pactl get-default-sink)
current_sink_index=$(echo "$sinks" | jq -r --arg name "$current_sink_name" 'map(.name) | index($name)')

if [[ $current_sink_index != "null" ]]; then
  next_sink_index=$(((current_sink_index + 1) % sinks_count))
else
  next_sink_index=0
fi

next_sink=$(echo "$sinks" | jq -r ".[$next_sink_index]")
next_sink_name=$(echo "$next_sink" | jq -r '.name')
next_sink_description=$(echo "$next_sink" | jq -r '.description')

# Fallback for Bluetooth devices with null description
if [[ $next_sink_description == "null" ]] || [[ -z $next_sink_description ]]; then
  device_id=$(echo "$next_sink" | jq -r '.properties."device.id"')
  if [[ $device_id != "null" ]] && [[ -n $device_id ]]; then
    next_sink_description=$(wpctl status | grep -E "^\s*│?\s+${device_id}\." | sed -E 's/^.*[0-9]+\.\s+//' | sed -E 's/\s+\[.*$//')
  fi
fi

if [[ $next_sink_name != $current_sink_name ]]; then
  pactl set-default-sink "$next_sink_name"
fi

notify-send "Audio output switched" "Now using: $next_sink_description" -u low -t 3000
