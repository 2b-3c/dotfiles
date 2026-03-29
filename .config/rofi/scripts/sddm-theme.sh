#!/usr/bin/env bash

ROFI_CONF="$HOME/.config/rofi"
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

rofi_menu() {
    rofi -dmenu -no-custom -config "$ROFI_CONF/launcher-menu.rasi"
}

# الثيمات المتاحة
CHOICE=$(printf '%s\n' \
    "Black Hole" \
    "Cyberpunk" \
    "Gruvbox Light" \
| rofi_menu)

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    "Black Hole")    THEME="black_hole" ;;
    "Cyberpunk")     THEME="cyberpunk" ;;
    "Gruvbox Light") THEME="gruvbox_light" ;;
    *) exit 0 ;;
esac

# فتح ترمينال لإدخال كلمة السر وتطبيق الثيم
kitty --title "SDDM Theme" bash -c "
    sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/${THEME}.conf|' \
        '${SDDM_THEME_DIR}/metadata.desktop' \
    && notify-send 'SDDM Theme' 'Theme changed to ${THEME}' --icon=preferences-desktop \
    || notify-send 'SDDM Theme' 'Failed to change theme' --icon=dialog-error
    echo ''
    echo 'Press Enter to close...'
    read
"
