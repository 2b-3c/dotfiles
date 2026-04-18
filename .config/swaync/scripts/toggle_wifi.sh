#!/usr/bin/env bash
set +e

# Right click → open rofi menu
if [[ $SWAYNC_TOGGLE_STATE == "menu" ]]; then
    swaync-client -t  # Close swaync first
    sleep 0.15
    bash "$HOME/.config/rofi/scripts/network-menu.sh" &
    exit 0
fi

# Left click → normal toggle
if [[ $SWAYNC_TOGGLE_STATE == true ]]; then
    rfkill unblock wifi
    nmcli radio wifi on
else
    nmcli radio wifi off
fi

exit 0
