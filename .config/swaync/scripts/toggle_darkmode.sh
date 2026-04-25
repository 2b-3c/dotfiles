#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   toggle_darkmode.sh — Switch between dark and light themes
#   Called from swaync panel toggle
# ─────────────────────────────────────────────────────────────────

CURRENT_FILE="$HOME/.config/omarchy/current/theme.name"
THEME_SET="$HOME/.config/hypr/scripts/theme-set.sh"

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null || echo "sky_blue")

# Map: current theme → opposite mode equivalent
declare -A DARK_TO_LIGHT=(
    [void_purple]="lavender"
    [deep_cyan]="sky_blue"
)
declare -A LIGHT_TO_DARK=(
    [lavender]="void_purple"
    [sakura_pink]="void_purple"
    [sky_blue]="deep_cyan"
    [inferno]="deep_cyan"
)

if [[ -v DARK_TO_LIGHT[$CURRENT] ]]; then
    TARGET="${DARK_TO_LIGHT[$CURRENT]}"
elif [[ -v LIGHT_TO_DARK[$CURRENT] ]]; then
    TARGET="${LIGHT_TO_DARK[$CURRENT]}"
else
    # Detect current mode via gsettings and toggle
    SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
    if [[ "$SCHEME" == *"dark"* ]]; then
        TARGET="sky_blue"
    else
        TARGET="void_purple"
    fi
fi

bash "$THEME_SET" "$TARGET"
