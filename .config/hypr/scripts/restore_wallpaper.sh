#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Restore last wallpaper on boot via awww
#   Falls back to Gruvbox Light wallpaper if no saved wallpaper found
# ─────────────────────────────────────────────────────────────────

DEFAULT_WALLPAPER="$HOME/Pictures/Wallpapers/themes/gruvbox-light.png"
SAVED_WALLPAPER="$HOME/.config/hypr/.current_wallpaper"

# ── Start awww-daemon ────────────────────────────────────────────
awww-daemon &
sleep 0.5

# ── Restore last or use default ─────────────────────────────────
if [[ -f "$SAVED_WALLPAPER" ]]; then
    WALLPAPER=$(cat "$SAVED_WALLPAPER")
    if [[ -f "$WALLPAPER" ]]; then
        awww img "$WALLPAPER" --transition-type none
        exit 0
    fi
fi

# ── Fallback to default ──────────────────────────────────────────
awww img "$DEFAULT_WALLPAPER" --transition-type none
echo "$DEFAULT_WALLPAPER" > "$SAVED_WALLPAPER"
