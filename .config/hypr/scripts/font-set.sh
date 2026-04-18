#!/bin/bash

# Set the system-wide monospace font used by kitty, hyprlock, waybar.
# Usage: font-set.sh <font-name>
# List available fonts: font-list.sh

font_name="$1"

if [[ -n $font_name ]]; then
  if fc-list | grep -iq "$font_name"; then
    if [[ -f ~/.config/kitty/kitty.conf ]]; then
      sed -i "s/^font_family .*/font_family $font_name/g" ~/.config/kitty/kitty.conf
      pkill -USR1 kitty
    fi

    if [[ -f ~/.config/hypr/hyprlock.conf ]]; then
      sed -i "s/font_family = .*/font_family = $font_name/g" ~/.config/hypr/hyprlock.conf
    fi

    if [[ -f ~/.config/waybar/style.css ]]; then
      sed -i "s/font-family: .*/font-family: '$font_name';/g" ~/.config/waybar/style.css
      pkill waybar; waybar &
    fi

    notify-send "Font changed" "Now using: $font_name" -u low -t 3000
  else
    notify-send "Font not found" "'$font_name' is not installed" -u critical -t 4000
    echo "Font '$font_name' not found."
    exit 1
  fi
else
  echo "Usage: font-set.sh <font-name>"
  echo "List fonts: font-list.sh"
fi
