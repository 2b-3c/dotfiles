#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Restore last wallpaper on boot via awww
#   Falls back to Gruvbox Light wallpaper if no saved wallpaper found
# ─────────────────────────────────────────────────────────────────

DEFAULT_WALLPAPER="$HOME/Pictures/Wallpapers/themes/gruvbox-light.png"
SAVED_WALLPAPER="$HOME/.config/hypr/.current_wallpaper"

# ── Start awww-daemon ────────────────────────────────────────────
awww-daemon &

# Wait until awww-daemon is ready instead of a fixed sleep
for _ in $(seq 1 20); do
    awww query --version &>/dev/null && break
    sleep 0.1
done

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
