#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Theme Switcher — Waybar · Kitty · Rofi · SwayNC · btop · cava
#                    Starship · Hyprland borders
# ─────────────────────────────────────────────────────────────────

ROFI_CONF="$HOME/.config/rofi"
CFG="$HOME/.config"

rofi_menu() {
    rofi -dmenu -no-custom -config "$ROFI_CONF/launcher-menu.rasi"
}

# ── قائمة الثيمات ────────────────────────────────────────────────
CHOICE=$(printf '%s\n' \
    "Black Hole" \
    "Cyberpunk" \
    "Gruvbox Light" \
| rofi_menu)

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    "Black Hole")
        THEME="pink-lavender"
        HYPR_ACTIVE="rgba(995d69ff) rgba(583264ff) 45deg"
        HYPR_INACTIVE="rgba(17132aaa)"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/black-hole.png"
        ;;
    "Cyberpunk")
        THEME="cyberpunk"
        HYPR_ACTIVE="rgba(f10354ff) rgba(147ea1ff) 45deg"
        HYPR_INACTIVE="rgba(111829aa)"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/cyberpunk.png"
        ;;
    "Gruvbox Light")
        THEME="gruvbox-light"
        HYPR_ACTIVE="rgba(6f6959ff) rgba(514f49ff) 45deg"
        HYPR_INACTIVE="rgba(ded1acaa)"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/gruvbox-light.png"
        ;;
    *) exit 0 ;;
esac

# ── Waybar ───────────────────────────────────────────────────────
[[ -f "$CFG/waybar/themes/$THEME.css" ]] && \
    cp "$CFG/waybar/themes/$THEME.css" "$CFG/waybar/theme.css" && \
    pkill waybar; waybar &disown

# ── Kitty ────────────────────────────────────────────────────────
[[ -f "$CFG/kitty/themes/$THEME.conf" ]] && \
    cp "$CFG/kitty/themes/$THEME.conf" "$CFG/kitty/theme.conf" && \
    kill -SIGUSR1 $(pgrep kitty) 2>/dev/null || true

# ── Rofi ─────────────────────────────────────────────────────────
[[ -f "$CFG/rofi/themes/$THEME.rasi" ]] && \
    cp "$CFG/rofi/themes/$THEME.rasi" "$CFG/rofi/themes/theme.rasi"

# ── SwayNC ───────────────────────────────────────────────────────
[[ -f "$CFG/swaync/themes/$THEME.css" ]] && \
    cp "$CFG/swaync/themes/$THEME.css" "$CFG/swaync/theme.css" && \
    swaync-client -rs 2>/dev/null || true

# ── btop ─────────────────────────────────────────────────────────
[[ -f "$CFG/btop/themes/$THEME.theme" ]] && \
    cp "$CFG/btop/themes/$THEME.theme" "$CFG/btop/themes/theme.theme"

# ── cava ─────────────────────────────────────────────────────────
if [[ -f "$CFG/cava/themes/$THEME" ]]; then
    COLORS=$(cat "$CFG/cava/themes/$THEME")
    sed -i '/^gradient/d; /^gradient_color/d' "$CFG/cava/config"
    # أضف الألوان بعد سطر [color]
    sed -i "/^\[color\]/a $COLORS" "$CFG/cava/config"
    pkill cava 2>/dev/null || true
fi

# ── Starship ─────────────────────────────────────────────────────
if [[ -f "$CFG/starship/themes/$THEME.toml" ]]; then
    STARSHIP_THEME=$(cat "$CFG/starship/themes/$THEME.toml")
    # تحديث الألوان في starship.toml
    while IFS= read -r section; do
        [[ "$section" =~ ^\[(.+)\]$ ]] && current="${BASH_REMATCH[1]}"
    done <<< "$STARSHIP_THEME"
    # نسخ الثيم الكامل فوق ملف الـ overrides
    cp "$CFG/starship/themes/$THEME.toml" "$CFG/starship/theme-colors.toml"
fi

# ── Hyprland borders ─────────────────────────────────────────────
hyprctl keyword general:col.active_border "$HYPR_ACTIVE" 2>/dev/null || true
hyprctl keyword general:col.inactive_border "$HYPR_INACTIVE" 2>/dev/null || true

# ── Wallpaper ─────────────────────────────────────────────────────
if [[ -f "$WALLPAPER" ]]; then
    if ! pgrep -x awww-daemon > /dev/null; then
        awww-daemon &
        sleep 0.5
    fi
    awww img "$WALLPAPER" \
        --transition-bezier .43,1.19,1,.4 \
        --transition-fps 60 \
        --transition-step 90 \
        --transition-type "grow" \
        --transition-duration 0.7
    echo "$WALLPAPER" > "$HOME/.config/hypr/.current_wallpaper"
fi

notify-send "Theme" "Switched to $CHOICE" --icon=preferences-desktop-theme
