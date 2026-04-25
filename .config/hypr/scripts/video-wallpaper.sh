#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   video-wallpaper.sh — Set a video as wallpaper using mpvpaper
#
#   Usage:
#     video-wallpaper.sh set <path/to/video>   — Set video wallpaper
#     video-wallpaper.sh stop                  — Stop video, restore image
#     video-wallpaper.sh toggle                — Toggle last video on/off
#
#   Requires: mpvpaper, awww
#   Video directory: ~/Pictures/Wallpapers/Videos/
# ─────────────────────────────────────────────────────────────────

SAVED_WALLPAPER="$HOME/.config/hypr/.current_wallpaper"
SAVED_VIDEO="$HOME/.config/hypr/.current_video_wallpaper"
VIDEO_DIR="$HOME/Pictures/Wallpapers/Videos"

# ── Ensure video directory exists ────────────────────────────────
mkdir -p "$VIDEO_DIR"

# ── Helper: stop any running video wallpaper ─────────────────────
stop_video() {
    pkill -x mpvpaper 2>/dev/null
}

# ── Helper: restore image wallpaper ──────────────────────────────
restore_image() {
    stop_video
    if ! pgrep -x awww-daemon > /dev/null; then
        awww-daemon &
        sleep 0.3
    fi
    local wallpaper
    wallpaper=$(cat "$SAVED_WALLPAPER" 2>/dev/null)
    if [[ -f "$wallpaper" ]]; then
        awww img "$wallpaper" --transition-type none
    fi
}

# ── Command: set <video_path> ─────────────────────────────────────
cmd_set() {
    local video="$1"
    if [[ -z "$video" || ! -f "$video" ]]; then
        notify-send -a "Video Wallpaper" "❌ File not found" "$video"
        exit 1
    fi

    # Stop awww-daemon (conflicts with mpvpaper on the wallpaper layer)
    pkill -x awww-daemon 2>/dev/null
    stop_video
    sleep 0.2

    # Launch mpvpaper on all monitors
    mpvpaper -o 'no-audio loop hwdec=auto vo=gpu gpu-context=wayland' '*' "$video" \
        >/dev/null 2>&1 &

    # Save the video path
    echo "$video" > "$SAVED_VIDEO"

    # Also update .current_wallpaper so restore_wallpaper.sh knows it's a video
    echo "$video" > "$SAVED_WALLPAPER"

    notify-send -a "Video Wallpaper" "▶ Video wallpaper set" "$(basename "$video")"
}

# ── Command: stop ─────────────────────────────────────────────────
cmd_stop() {
    restore_image
    rm -f "$SAVED_VIDEO"
    notify-send -a "Video Wallpaper" "⏹ Video wallpaper stopped"
}

# ── Command: toggle ───────────────────────────────────────────────
cmd_toggle() {
    if pgrep -x mpvpaper > /dev/null; then
        cmd_stop
    else
        local video
        video=$(cat "$SAVED_VIDEO" 2>/dev/null)
        if [[ -f "$video" ]]; then
            cmd_set "$video"
        else
            notify-send -a "Video Wallpaper" "ℹ No video saved" "Use the wallpaper selector first"
        fi
    fi
}

# ── Main ─────────────────────────────────────────────────────────
case "$1" in
    set)    cmd_set "$2" ;;
    stop)   cmd_stop ;;
    toggle) cmd_toggle ;;
    *)
        echo "Usage: video-wallpaper.sh <set <path>|stop|toggle>"
        exit 1
        ;;
esac
