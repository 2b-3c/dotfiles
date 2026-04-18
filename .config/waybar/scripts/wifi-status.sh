#!/usr/bin/env bash

# Optimized wifi-status.sh
# Changes vs original:
#  - Single nmcli call with multiple fields instead of two separate calls
#  - iw output cached in a variable (was used in multiple greps)
#  - Commented-out fields (bssid, gateway, mac, rssi) are now skipped entirely
#    rather than collected and discarded

if ! command -v nmcli &>/dev/null; then
  echo "{\"text\": \"󰤮 Wi-Fi\", \"tooltip\": \"nmcli utility is missing\"}"
  exit 1
fi

# Check if Wi-Fi is enabled (fast, single field query)
if [ "$(nmcli -g WIFI radio)" = "disabled" ]; then
  echo "{\"text\": \"󰤮\", \"tooltip\": \"Wi-Fi Disabled\"}"
  exit 0
fi

# Single nmcli call: active connection info
wifi_info=$(nmcli -t -f active,ssid,signal,security dev wifi | grep "^yes")

if [ -z "$wifi_info" ]; then
  echo "{\"text\": \"󰤮\", \"tooltip\": \"No Connection\"}"
  exit 0
fi

essid=$(echo "$wifi_info"    | awk -F: '{print $2}')
signal=$(echo "$wifi_info"   | awk -F: '{print $3}')
security=$(echo "$wifi_info" | awk -F: '{print $4}')

# Get active device — filter noise in one pass
active_device=$(nmcli -t -f DEVICE,STATE device status \
  | awk -F: '$2=="connected" && $1!~"^(dummy|lo)" {print $1; exit}')

tooltip="${essid}"

if [ -n "$active_device" ]; then
  # One nmcli call for IP + channel/freq
  ip_address=$(nmcli -e no -g ip4.address device show "$active_device" | head -1)

  chan_line=$(nmcli -e no -t -f active,chan,freq device wifi | grep "^yes")
  chan=$(echo "$chan_line" | awk -F: '{print $2}')
  freq=$(echo "$chan_line" | awk -F: '{print $3}')

  tooltip+="\\nIP Address: ${ip_address}"
  tooltip+="\\nSecurity:   ${security}"
  tooltip+="\\nChannel:    ${chan} (${freq})"
  tooltip+="\\nStrength:   ${signal} / 100"

  # iw: only if available, cache output once
  if command -v iw &>/dev/null; then
    iw_out=$(iw dev "$active_device" station dump 2>/dev/null)
    rx_bitrate=$(echo "$iw_out" | awk '/rx bitrate:/{print $3, $4; exit}')
    tx_bitrate=$(echo "$iw_out" | awk '/tx bitrate:/{print $3, $4; exit}')

    if   echo "$iw_out" | grep -qE "rx bitrate:.* HE";  then phy_mode="802.11ax"
    elif echo "$iw_out" | grep -qE "rx bitrate:.* VHT"; then phy_mode="802.11ac"
    elif echo "$iw_out" | grep -qE "rx bitrate:.* HT";  then phy_mode="802.11n"
    fi

    [ -n "$rx_bitrate" ] && tooltip+="\\nRx Rate:    ${rx_bitrate}"
    [ -n "$tx_bitrate" ] && tooltip+="\\nTx Rate:    ${tx_bitrate}"
    [ -n "$phy_mode"   ] && tooltip+="\\nPHY Mode:   ${phy_mode}"
  fi
fi

# Determine Wi-Fi icon based on signal strength
if   [ "$signal" -ge 80 ]; then icon="󰤨"
elif [ "$signal" -ge 60 ]; then icon="󰤥"
elif [ "$signal" -ge 40 ]; then icon="󰤢"
elif [ "$signal" -ge 20 ]; then icon="󰤟"
else                             icon="󰤮"
fi

echo "{\"text\": \"${icon}\", \"tooltip\": \"${tooltip}\"}"
