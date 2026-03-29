#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Wallpaper Selector — Rofi + awww
#   Shows a rofi menu with wallpaper previews and icons
#   Default directory: ~/Pictures/Wallpapers
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

if [[ ${#images[@]} -eq 0 ]]; then
    notify-send -a "Wallpaper Selector" "❌ No images found in" "$WALLPAPER_DIR"
    exit 1
fi

# ── Build rofi list with icons ──────────────────────────────────
image_list=""
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

# ── Find full path ──────────────────────────────────────────────
selected_path=""
for img in "${images[@]}"; do
    name=$(basename "$img" | sed 's/\.[^.]*$//')
    if [[ "$name" == "$selected" ]]; then
        selected_path="$img"
        break
    fi
done

[[ -z "$selected_path" ]] && exit 1

# ── Apply wallpaper via awww ────────────────────────────────────
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

# ── Save path for restore on boot ──────────────────────────────
echo "$selected_path" > "$HOME/.config/hypr/.current_wallpaper"

notify-send -a "Wallpaper Selector" "✓ Wallpaper changed" "$(basename "$selected_path")" \
    -i "$selected_path"
