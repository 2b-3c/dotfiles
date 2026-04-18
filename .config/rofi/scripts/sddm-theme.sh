#!/usr/bin/env bash

ROFI_CONF="$HOME/.config/rofi"
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

rofi_menu() {
    local input
    input=$(cat)
    local count
    count=$(echo "$input" | grep -c .)
    echo "$input" | rofi -dmenu -no-custom \
        -config "$ROFI_CONF/launcher-menu.rasi" \
        -lines "$count" \
        -theme-str "listview { lines: ${count}; } window { width: 260px; }"
}

CHOICE=$(printf '%s\n' \
    "Gruvbox Light" \
    "Gruvbox Dark" \
| rofi_menu)

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    "Gruvbox Light") THEME="gruvbox_light" ;;
    "Gruvbox Dark")  THEME="gruvbox_dark"  ;;
    *) exit 0 ;;
esac

kitty --title "SDDM Theme" bash -c "
    sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/${THEME}.conf|' \
        '${SDDM_THEME_DIR}/metadata.desktop' \
    && notify-send 'SDDM Theme' 'Theme changed to ${THEME}' --icon=preferences-desktop \
    || notify-send 'SDDM Theme' 'Failed to change theme' --icon=dialog-error
    echo ''
    echo 'Press Enter to close...'
    read
"
