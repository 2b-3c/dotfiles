#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   network-menu.sh — WiFi connection picker via rofi + nmcli
# ─────────────────────────────────────────────────────────────────

ROFI_CONF="$HOME/.config/rofi"

rofi_menu() {
    local input count
    input=$(cat)
    count=$(echo "$input" | grep -c .)
    echo "$input" | rofi -dmenu -no-custom \
        -config "$ROFI_CONF/launcher-menu.rasi" \
        -lines "$count" \
        -theme-str "listview { lines: ${count}; } window { width: 360px; }"
}

# Scan for networks
nmcli radio wifi on 2>/dev/null
NETWORKS=$(nmcli -t -f SSID,SIGNAL,SECURITY dev wifi list 2>/dev/null \
    | awk -F: '
        $1 != "" {
            ssid=$1; sig=$2; sec=$3
            if (sig >= 80) icon="󰤨"
            else if (sig >= 60) icon="󰤥"
            else if (sig >= 40) icon="󰤢"
            else if (sig >= 20) icon="󰤟"
            else icon="󰤮"
            lock = (sec != "--" && sec != "") ? "  " : ""
            printf "%s  %s%s (%s%%)\n", icon, ssid, lock, sig
        }' \
    | sort -u | head -20)

[[ -z "$NETWORKS" ]] && notify-send "Wi-Fi" "No networks found" && exit 0

CHOICE=$(echo "$NETWORKS" | rofi_menu)
[[ -z "$CHOICE" ]] && exit 0

# Extract SSID (strip icon and signal suffix)
SSID=$(echo "$CHOICE" | sed 's/^[^ ]* *//' | sed 's/  .*//' | sed 's/ ([0-9]*%)//')

# Try to connect (saved profile first, then prompt for password)
if nmcli connection show "$SSID" &>/dev/null; then
    nmcli connection up "$SSID" && \
        notify-send "Wi-Fi" "Connected to $SSID" || \
        notify-send -u critical "Wi-Fi" "Failed to connect to $SSID"
else
    # Ask for password via rofi
    PASS=$(rofi -dmenu -password \
        -config "$ROFI_CONF/launcher-menu.rasi" \
        -p "Password for $SSID" \
        -theme-str "window { width: 360px; }" \
        <<< "")
    [[ -z "$PASS" ]] && exit 0
    nmcli device wifi connect "$SSID" password "$PASS" && \
        notify-send "Wi-Fi" "Connected to $SSID" || \
        notify-send -u critical "Wi-Fi" "Wrong password or failed"
fi
