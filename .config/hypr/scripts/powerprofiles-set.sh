#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   powerprofiles-set.sh — Set power profile (ac | battery)
#   Uses powerprofilesctl; falls back to balanced if performance
#   is unavailable on this machine.
#   Usage: powerprofiles-set.sh <ac|battery|toggle>
# ══════════════════════════════════════════════════════════════════

if ! command -v powerprofilesctl &>/dev/null; then
  exit 0
fi

mapfile -t profiles < <(powerprofilesctl list | awk '/^\s*[* ]\s*[a-zA-Z0-9\-]+:$/ { gsub(/^[*[:space:]]+|:$/,""); print }')

current_profile=$(powerprofilesctl get)

set_profile() {
  local target="$1"
  powerprofilesctl set "$target"
  notify-send "Power profile" "Switched to: $target" -u low -t 2500
}

case "$1" in
  ac)
    if [[ " ${profiles[*]} " == *" performance "* ]]; then
      set_profile "performance"
    else
      set_profile "balanced"
    fi
    ;;
  battery)
    set_profile "balanced"
    ;;
  toggle)
    if [[ "$current_profile" == "performance" ]]; then
      set_profile "balanced"
    elif [[ " ${profiles[*]} " == *" performance "* ]]; then
      set_profile "performance"
    else
      set_profile "balanced"
    fi
    ;;
  *)
    echo "Usage: powerprofiles-set.sh <ac|battery|toggle>"
    exit 1
    ;;
esac
