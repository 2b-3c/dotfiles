#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Theme Switcher — Waybar · Kitty · Rofi · SwayNC · btop · cava
#                    Starship · Hyprland borders · GTK · Nautilus
# ─────────────────────────────────────────────────────────────────

ROFI_CONF="$HOME/.config/rofi"
CFG="$HOME/.config"
COLORS_CONF="$HOME/.config/hypr/colors.conf"

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

# ── Theme list ────────────────────────────────────────────────
CHOICE=$(printf '%s\n' \
    "Gruvbox Light" \
    "Gruvbox" \
    "Retro-82" \
    "Ristretto" \
    "White" \
    "Miasma" \
    "Osaka-Jade" \
    "Tokyo Night" \
    "Vantablack" \
| rofi_menu)

[ -z "$CHOICE" ] && exit 0

case "$CHOICE" in
    "Gruvbox Light")
        THEME="gruvbox-light"
        HYPR_ACTIVE="rgba(6f6959ff) rgba(514f49ff) 45deg"
        HYPR_INACTIVE="rgba(ded1acaa)"
        SHADOW_COLOR="0xAA514f49"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/gruvbox-light.png"
        GTK_THEME="Adwaita"
        GTK_COLOR_SCHEME="prefer-light"
        GTK_ICON_THEME="Yaru-bark"
        ;;
    "Gruvbox")
        THEME="gruvbox"
        HYPR_ACTIVE="rgba(7daea3ff) rgba(a9b665ff) 45deg"
        HYPR_INACTIVE="rgba(3c3836aa)"
        SHADOW_COLOR="0xCC282828"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/gruvbox.jpg"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-olive-dark"
        ;;
    "Retro-82")
        THEME="retro-82"
        HYPR_ACTIVE="rgba(faa968ff) rgba(e97b3cff) 45deg"
        HYPR_INACTIVE="rgba(134e5aaa)"
        SHADOW_COLOR="0xCC05182e"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/retro-82.jpg"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-prussiangreen-dark"
        ;;
    "Ristretto")
        THEME="ristretto"
        HYPR_ACTIVE="rgba(f38d70ff) rgba(fd6883ff) 45deg"
        HYPR_INACTIVE="rgba(3d3536aa)"
        SHADOW_COLOR="0xCC2c2525"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/ristretto.jpg"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-red-dark"
        ;;
    "White")
        THEME="white"
        HYPR_ACTIVE="rgba(6e6e6eff) rgba(1a1a1aff) 45deg"
        HYPR_INACTIVE="rgba(d0d0d0aa)"
        SHADOW_COLOR="0x44000000"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/white.jpg"
        GTK_THEME="Adwaita"
        GTK_COLOR_SCHEME="prefer-light"
        GTK_ICON_THEME="Yaru-bark"
        ;;
    "Miasma")
        THEME="miasma"
        HYPR_ACTIVE="rgba(78824bff) rgba(c9a554ff) 45deg"
        HYPR_INACTIVE="rgba(2c2c2caa)"
        SHADOW_COLOR="0xCC222222"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/miasma.jpg"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-olive-dark"
        ;;
    "Osaka-Jade")
        THEME="osaka-jade"
        HYPR_ACTIVE="rgba(509475ff) rgba(2DD5B7ff) 45deg"
        HYPR_INACTIVE="rgba(23372Baa)"
        SHADOW_COLOR="0xCC111c18"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/osaka-jade.jpg"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-viridian-dark"
        ;;
    "Tokyo Night")
        THEME="tokyo-night"
        HYPR_ACTIVE="rgba(7aa2f7ff) rgba(ad8ee6ff) 45deg"
        HYPR_INACTIVE="rgba(32344aaa)"
        SHADOW_COLOR="0xCC1a1b26"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/tokyo-night.png"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-blue-dark"
        ;;
    "Vantablack")
        THEME="vantablack"
        HYPR_ACTIVE="rgba(8d8d8dff) rgba(b0b0b0ff) 45deg"
        HYPR_INACTIVE="rgba(1a1a1aaa)"
        SHADOW_COLOR="0xDD0d0d0d"
        WALLPAPER="$HOME/Pictures/Wallpapers/themes/vantablack.jpg"
        GTK_THEME="Adwaita-dark"
        GTK_COLOR_SCHEME="prefer-dark"
        GTK_ICON_THEME="Yaru-bark-dark"
        ;;
    *) exit 0 ;;
esac

# ── Save current theme name (used by fastfetch) ──────────────────
mkdir -p "$HOME/.config/omarchy/current"
echo "$THEME" > "$HOME/.config/omarchy/current/theme.name"

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
    sed -i "/^\[color\]/a $COLORS" "$CFG/cava/config"
    pkill cava 2>/dev/null || true
fi

# ── Starship ─────────────────────────────────────────────────────
if [[ -f "$CFG/starship/themes/$THEME.toml" ]]; then
    cp "$CFG/starship/themes/$THEME.toml" "$CFG/starship/theme-colors.toml"
fi

# ── GTK + Nautilus folder icons ──────────────────────────────────
if [[ -f "$CFG/gtk-3.0/themes/$THEME.css" ]]; then
    cp "$CFG/gtk-3.0/themes/$THEME.css" "$CFG/gtk-3.0/gtk.css"
fi
if [[ -f "$CFG/gtk-4.0/themes/$THEME.css" ]]; then
    cp "$CFG/gtk-4.0/themes/$THEME.css" "$CFG/gtk-4.0/gtk.css"
fi
if [[ -f "$CFG/gtk-3.0/themes/$THEME.ini" ]]; then
    cp "$CFG/gtk-3.0/themes/$THEME.ini" "$CFG/gtk-3.0/settings.ini"
fi
if [[ -f "$CFG/gtk-4.0/themes/$THEME.ini" ]]; then
    cp "$CFG/gtk-4.0/themes/$THEME.ini" "$CFG/gtk-4.0/settings.ini"
fi

# Apply via gsettings (same method as omarchy-theme-set-gnome)
gsettings set org.gnome.desktop.interface gtk-theme        "$GTK_THEME"        2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme     "$GTK_COLOR_SCHEME" 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme     "Bibata-Modern-Classic" 2>/dev/null || true

# Read icon theme from per-theme file (omarchy-style: each theme defines its own icons)
# Fallback: Yaru-dark for dark themes, Yaru for light themes
_ICONS_FILE="$CFG/icons-themes/$THEME"
if [[ -f "$_ICONS_FILE" ]]; then
    _RESOLVED_ICON="$(cat "$_ICONS_FILE" | tr -d '[:space:]')"
elif [[ "$GTK_COLOR_SCHEME" == "prefer-dark" ]]; then
    _RESOLVED_ICON="Yaru-dark"
else
    _RESOLVED_ICON="Yaru"
fi
# Final safety check — if the resolved icon theme isn't installed, fall back
if [[ ! -d "/usr/share/icons/$_RESOLVED_ICON" ]]; then
    [[ "$GTK_COLOR_SCHEME" == "prefer-dark" ]] && _RESOLVED_ICON="Yaru-dark" || _RESOLVED_ICON="Yaru"
fi
gsettings set org.gnome.desktop.interface icon-theme "$_RESOLVED_ICON" 2>/dev/null || true
sudo gtk-update-icon-cache /usr/share/icons/"$_RESOLVED_ICON" 2>/dev/null || true

# Nautilus picks up gsettings changes live — no restart needed
# (same approach used by omarchy-theme-set-gnome)

# ── Hyprland borders ─────────────────────────────────────────────
cat > "$COLORS_CONF" << CONF
# This file is auto-generated by theme-select.sh — do not edit manually
general {
    col.active_border = $HYPR_ACTIVE
    col.inactive_border = $HYPR_INACTIVE
}
decoration:shadow {
    color = $SHADOW_COLOR
    color_inactive = $SHADOW_COLOR
}
CONF

hyprctl keyword general:col.active_border "$HYPR_ACTIVE" 2>/dev/null || true
hyprctl keyword general:col.inactive_border "$HYPR_INACTIVE" 2>/dev/null || true
hyprctl keyword decoration:shadow:color "$SHADOW_COLOR" 2>/dev/null || true
hyprctl keyword decoration:shadow:color_inactive "$SHADOW_COLOR" 2>/dev/null || true

# ── SDDM ─────────────────────────────────────────────────────────
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
SDDM_CONF="${THEME//-/_}"
[[ -f "$SDDM_THEME_DIR/Themes/${SDDM_CONF}.conf" ]] && \
    sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/${SDDM_CONF}.conf|" \
    "$SDDM_THEME_DIR/metadata.desktop" 2>/dev/null || true

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
