#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   sddm-theme.sh — SDDM theme switcher
#   astronaut themes: void_purple, sky_blue, deep_cyan, lavender, inferno
#   silent themes:    sakura_pink
# ─────────────────────────────────────────────────────────────────

ROFI_CONF="$HOME/.config/rofi"
ASTRONAUT_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
SILENT_DIR="/usr/share/sddm/themes/silent"   # Fixed: was SilentSDDM

rofi_menu() {
    local input count
    input=$(cat)
    count=$(echo "$input" | grep -c .)
    echo "$input" | rofi -dmenu -no-custom \
        -config "$ROFI_CONF/launcher-menu.rasi" \
        -lines "$count" \
        -theme-str "listview { lines: ${count}; } window { width: 300px; }"
}

CHOICE=$(printf '%s\n' \
    "Void Purple" \
    "Deep Cyan" \
    "Sky Blue" \
    "Lavender" \
    "Inferno" \
    "Sakura Pink" \
| rofi_menu)

[[ -z "$CHOICE" ]] && exit 0

case "$CHOICE" in
    "Void Purple") THEME="void_purple"; THEME_DIR="$ASTRONAUT_DIR"; CONFIG_PATH="Themes/${THEME}.conf" ;;
    "Deep Cyan")   THEME="deep_cyan";   THEME_DIR="$ASTRONAUT_DIR"; CONFIG_PATH="Themes/${THEME}.conf" ;;
    "Sky Blue")    THEME="sky_blue";    THEME_DIR="$ASTRONAUT_DIR"; CONFIG_PATH="Themes/${THEME}.conf" ;;
    "Lavender")    THEME="lavender";    THEME_DIR="$ASTRONAUT_DIR"; CONFIG_PATH="Themes/${THEME}.conf" ;;
    "Inferno")     THEME="inferno";     THEME_DIR="$ASTRONAUT_DIR"; CONFIG_PATH="Themes/${THEME}.conf" ;;
    "Sakura Pink") THEME="sakura_pink"; THEME_DIR="$SILENT_DIR";    CONFIG_PATH="configs/${THEME}.conf" ;;
    *) exit 0 ;;
esac

kitty --title "SDDM Theme" bash -c "
    set -e

    # Verify theme dir exists
    if [[ ! -d '${THEME_DIR}' ]]; then
        echo 'Error: SDDM theme directory not found: ${THEME_DIR}'
        echo 'Run the installer first.'
        echo ''
        read -rp 'Press Enter to close...'
        exit 1
    fi

    # Switch active SDDM theme in /etc/sddm.conf
    sudo sed -i 's|^Current=.*|Current=${THEME_DIR##*/}|' /etc/sddm.conf 2>/dev/null || \
        echo '[Theme]' | sudo tee /etc/sddm.conf > /dev/null && \
        echo 'Current=${THEME_DIR##*/}' | sudo tee -a /etc/sddm.conf > /dev/null

    # Update ConfigFile inside the theme metadata.desktop
    if [[ -f '${THEME_DIR}/metadata.desktop' ]]; then
        sudo sed -i 's|^ConfigFile=.*|ConfigFile=${CONFIG_PATH}|' \
            '${THEME_DIR}/metadata.desktop' && \
        notify-send 'SDDM Theme' 'Changed to ${CHOICE}' --icon=preferences-desktop || \
        notify-send 'SDDM Theme' 'Failed to update metadata' --icon=dialog-error
    else
        echo 'Warning: metadata.desktop not found in ${THEME_DIR}'
    fi

    echo ''
    echo 'Theme set to: ${CHOICE}'
    echo 'Changes take effect on next login screen.'
    echo ''
    read -rp 'Press Enter to close...'
"
