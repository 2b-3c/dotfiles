#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Wallpaper Selector — Rofi + awww
#   Shows images + a "Video Wallpaper" entry to launch video picker
#   Default image directory: ~/Pictures/Wallpapers
# ─────────────────────────────────────────────────────────────────

WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Pictures/Wallpapers}"
ROFI_CONFIG="$HOME/.config/rofi/wallpaper-select.rasi"

# ── Check directory exists ───────────────────────────────────────
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    notify-send -a "Wallpaper Selector" "❌ Directory not found" "$WALLPAPER_DIR"
    exit 1
fi

# ── Collect images (png, jpg, jpeg, webp) ───────────────────────
mapfile -t images < <(find "$WALLPAPER_DIR" -maxdepth 1 \
    -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) \
    | sort)

# ── Build rofi list ──────────────────────────────────────────────
image_list=""

# Special entry: open video wallpaper picker
image_list+="󰎁  Video Wallpaper\x00icon\x1fvideo-x-generic\n"

# Special entry: stop video (only shown if mpvpaper is running)
if pgrep -x mpvpaper > /dev/null; then
    image_list+="⏹  Stop Video Wallpaper\x00icon\x1fprocess-stop\n"
fi

for img in "${images[@]}"; do
    name=$(basename "$img" | sed 's/\.[^.]*$//')
    image_list+="${name}\x00icon\x1f${img}\n"
done

# ── Show rofi menu ──────────────────────────────────────────────
selected=$(printf '%b' "$image_list" \
    | rofi -dmenu \
           -theme "$ROFI_CONFIG" \
           -p "󰹉  Wallpaper")

[[ -z "$selected" ]] && exit 0

# ── Handle special entries ───────────────────────────────────────
if [[ "$selected" == "󰎁  Video Wallpaper" ]]; then
    bash "$HOME/.config/rofi/scripts/video-wallpaper-select.sh"
    exit 0
fi

if [[ "$selected" == "⏹  Stop Video Wallpaper" ]]; then
    bash "$HOME/.config/hypr/scripts/video-wallpaper.sh" stop
    exit 0
fi

# ── Find full path of selected image ────────────────────────────
selected_path=""
for img in "${images[@]}"; do
    name=$(basename "$img" | sed 's/\.[^.]*$//')
    if [[ "$name" == "$selected" ]]; then
        selected_path="$img"
        break
    fi
done

[[ -z "$selected_path" ]] && exit 1

# ── Stop any running video wallpaper first ───────────────────────
if pgrep -x mpvpaper > /dev/null; then
    pkill -x mpvpaper
    rm -f "$HOME/.config/hypr/.current_video_wallpaper"
    # Start awww-daemon if not running
    if ! pgrep -x awww-daemon > /dev/null; then
        awww-daemon &
        sleep 0.3
    fi
fi

# ── Apply image wallpaper via awww ───────────────────────────────
if ! pgrep -x awww-daemon > /dev/null; then
    awww-daemon &
    sleep 0.5
fi

awww img "$selected_path" \
    --transition-bezier .43,1.19,1,.4 \
    --transition-fps 60 \
    --transition-step 90 \
    --transition-type "grow" \
    --transition-duration 0.7 \
    --invert-y \
    --transition-pos "$(hyprctl cursorpos)"

# ── Save path for restore on boot ───────────────────────────────
echo "$selected_path" > "$HOME/.config/hypr/.current_wallpaper"

notify-send -a "Wallpaper Selector" "✓ Wallpaper changed" "$(basename "$selected_path")" \
    -i "$selected_path"
