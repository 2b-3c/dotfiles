#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   video-wallpaper-select.sh — Pick a video wallpaper via Rofi
#   Scans ~/Pictures/Wallpapers/Videos/ for video files
#   Requires: mpvpaper, rofi-wayland
# ─────────────────────────────────────────────────────────────────

VIDEO_DIR="${VIDEO_DIR:-$HOME/Pictures/Wallpapers/Videos}"
ROFI_CONFIG="$HOME/.config/rofi/wallpaper-select.rasi"
SCRIPT="$HOME/.config/hypr/scripts/video-wallpaper.sh"

# ── Check directory ───────────────────────────────────────────────
if [[ ! -d "$VIDEO_DIR" ]]; then
    notify-send -a "Video Wallpaper" "❌ Videos directory not found" "$VIDEO_DIR"
    mkdir -p "$VIDEO_DIR"
    notify-send -a "Video Wallpaper" "📁 Created directory" "$VIDEO_DIR — Add your videos there"
    exit 0
fi

# ── Collect videos ────────────────────────────────────────────────
mapfile -t videos < <(find "$VIDEO_DIR" -maxdepth 2 \
    -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \
              -o -iname "*.mov" -o -iname "*.avi" -o -iname "*.gif" \) \
    | sort)

if [[ ${#videos[@]} -eq 0 ]]; then
    notify-send -a "Video Wallpaper" "❌ No videos found" \
        "Add .mp4 / .mkv / .webm files to $VIDEO_DIR"
    exit 0
fi

# ── Special option: stop current video ───────────────────────────
STOP_ENTRY=""
if pgrep -x mpvpaper > /dev/null; then
    STOP_ENTRY="⏹  Stop video wallpaper\x00icon\x1fprocess-stop\n"
fi

# ── Build rofi list ───────────────────────────────────────────────
video_list="$STOP_ENTRY"
for vid in "${videos[@]}"; do
    name=$(basename "$vid" | sed 's/\.[^.]*$//')
    # Use a video/film icon; rofi will fallback gracefully if icon not found
    video_list+="${name}  󰎁\x00icon\x1fvideo-x-generic\n"
done

# ── Show rofi menu ────────────────────────────────────────────────
selected=$(printf '%b' "$video_list" \
    | rofi -dmenu \
           -theme "$ROFI_CONFIG" \
           -p "󰎁  Video Wallpaper")

[[ -z "$selected" ]] && exit 0

# ── Handle stop option ────────────────────────────────────────────
if [[ "$selected" == "⏹  Stop video wallpaper" ]]; then
    bash "$SCRIPT" stop
    exit 0
fi

# ── Find full path ────────────────────────────────────────────────
# Strip the icon suffix we added
clean_name="${selected%  󰎁}"
selected_path=""
for vid in "${videos[@]}"; do
    name=$(basename "$vid" | sed 's/\.[^.]*$//')
    if [[ "$name" == "$clean_name" ]]; then
        selected_path="$vid"
        break
    fi
done

[[ -z "$selected_path" ]] && exit 1

bash "$SCRIPT" set "$selected_path"
