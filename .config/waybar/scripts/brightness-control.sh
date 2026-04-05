#!/usr/bin/env bash

# Print error message for invalid arguments
print_error() {
  cat <<"EOF"
Usage: ./brightnesscontrol.sh <action>
Valid actions are:
    i -- <i>ncrease brightness [+2%]
    d -- <d>ecrease brightness [-2%]
EOF
}

# Get the current brightness — single brightnessctl call, parse all fields from it
get_brightness() {
  local _raw
  _raw=$(brightnessctl -m | head -n 1)
  brightness=$(echo "$_raw" | grep -o '[0-9]\+%' | head -c-2)
  device=$(echo "$_raw"     | awk -F',' '{print $1}' | sed 's/_/ /g; s/\<./\U&/g')
  current_brightness=$(echo "$_raw" | awk -F',' '{print $3}')
  max_brightness=$(echo "$_raw"     | awk -F',' '{print $5}')
}
get_brightness

# Pick icon based on brightness level
get_icon() {
  if   ((brightness <=  5)); then icon="󰃞"
  elif ((brightness <= 15)); then icon="󰃟"
  elif ((brightness <= 30)); then icon="󰃠"
  elif ((brightness <= 45)); then icon="󰃡"
  elif ((brightness <= 55)); then icon="󰃢"
  elif ((brightness <= 65)); then icon="󰃣"
  elif ((brightness <= 80)); then icon="󰃤"
  elif ((brightness <= 95)); then icon="󰃥"
  else                            icon="󰃦"
  fi
}

# Handle options
while getopts o: opt; do
  case "${opt}" in
  o)
    case $OPTARG in
    i) # Increase brightness
      if [[ $brightness -lt 10 ]]; then
        brightnessctl set +1%
      else
        brightnessctl set +2%
      fi
      ;;
    d) # Decrease brightness
      if [[ $brightness -le 1 ]]; then
        brightnessctl set 1%
      elif [[ $brightness -le 10 ]]; then
        brightnessctl set 1%-
      else
        brightnessctl set 2%-
      fi
      ;;
    *)
      print_error
      ;;
    esac
    ;;
  *)
    print_error
    ;;
  esac
done

# Waybar module output
get_icon
module="${icon} ${brightness}%"
tooltip="Device Name: ${device}"
tooltip+="\nBrightness:  ${current_brightness} / ${max_brightness}"
echo "{\"text\": \"${module}\", \"tooltip\": \"${tooltip}\"}"
