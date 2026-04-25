#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Restore last wallpaper on boot (image or video)
#   Falls back to current theme wallpaper, then first available
# ─────────────────────────────────────────────────────────────────

SAVED_WALLPAPER="$HOME/.config/hypr/.current_wallpaper"
SAVED_VIDEO="$HOME/.config/hypr/.current_video_wallpaper"
CURRENT_THEME_FILE="$HOME/.config/omarchy/current/theme.name"
THEMES_DIR="$HOME/.config/themes"

# ── Video extensions helper ──────────────────────────────────────
is_video() {
    local file="$1"
    [[ "$file" =~ \.(mp4|mkv|webm|mov|avi|gif)$ ]]
}

# ── Resolve default wallpaper from current theme ─────────────────
resolve_default_wallpaper() {
    local theme
    theme=$(cat "$CURRENT_THEME_FILE" 2>/dev/null || echo "sky_blue")
    local wall
    wall=$(find "$THEMES_DIR" -mindepth 3 -maxdepth 3 \
        -path "*/${theme}/wallpaper.*" 2>/dev/null | head -1)
    if [[ -z "$wall" ]]; then
        # Fallback: any wallpaper from any theme
        wall=$(find "$THEMES_DIR" -name "wallpaper.*" 2>/dev/null | head -1)
    fi
    echo "$wall"
}

# ── Check if last wallpaper was a video ─────────────────────────
if [[ -f "$SAVED_VIDEO" ]]; then
    VIDEO=$(cat "$SAVED_VIDEO")
    if [[ -f "$VIDEO" ]]; then
        sleep 1
        mpvpaper -o 'no-audio loop hwdec=auto vo=gpu gpu-context=wayland' '*' "$VIDEO" \
            >/dev/null 2>&1 &
        exit 0
    fi
    # Stale video reference — clean up
    rm -f "$SAVED_VIDEO"
fi

# ── Start awww-daemon for image wallpaper ────────────────────────
awww-daemon &

for _ in $(seq 1 20); do
    awww query --version &>/dev/null && break
    sleep 0.1
done

# ── Restore last image or use theme default ──────────────────────
if [[ -f "$SAVED_WALLPAPER" ]]; then
    WALLPAPER=$(cat "$SAVED_WALLPAPER")
    if [[ -f "$WALLPAPER" ]] && ! is_video "$WALLPAPER"; then
        awww img "$WALLPAPER" --transition-type none
        exit 0
    fi
fi

# ── Fallback to current theme wallpaper ─────────────────────────
DEFAULT=$(resolve_default_wallpaper)
if [[ -n "$DEFAULT" && -f "$DEFAULT" ]]; then
    awww img "$DEFAULT" --transition-type none
    echo "$DEFAULT" > "$SAVED_WALLPAPER"
else
    notify-send "Wallpaper" "⚠ No wallpaper found. Add images to ~/Pictures/Wallpapers" -u low
fi
