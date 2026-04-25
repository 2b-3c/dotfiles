#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────
#   Image Clipboard — Rofi thumbnail picker
# ─────────────────────────────────────────────────────────────────

ROFI_CONFIG="$HOME/.config/rofi/image-clipboard.rasi"
THUMB_DIR="/tmp/rofi-clipboard-thumbs"
mkdir -p "$THUMB_DIR"

# ── Filter images directly by text [[ binary data ────────────────────
mapfile -t IMG_LINES < <(cliphist list 2>/dev/null | grep '^\S*\s*\[\[ binary data')

if [ ${#IMG_LINES[@]} -eq 0 ]; then
    notify-send "Clipboard" "No images in clipboard history" --icon=dialog-information
    exit 0
fi

# ── Build rofi list with thumbnails ───────────────────────────────
ROFI_INPUT=""
for LINE in "${IMG_LINES[@]}"; do
    CLIP_ID=$(echo "$LINE" | cut -f1)
    SAFE_ID=$(echo "$CLIP_ID" | tr -dc '0-9a-zA-Z_-')
    THUMB="$THUMB_DIR/clip_${SAFE_ID}.png"

    if [ ! -f "$THUMB" ]; then
        cliphist decode <<< "$LINE" | \
            convert - -thumbnail 84x84^ -gravity center -extent 84x84 "$THUMB" 2>/dev/null || true
    fi

    # label from cliphist description e.g. "png 377x125"
    LABEL=$(echo "$LINE" | grep -oP '\d+ KiB \w+ \d+x\d+' || echo "Image $CLIP_ID")
    [ -f "$THUMB" ] && ROFI_INPUT+="${CLIP_ID}\x00icon\x1f${THUMB}\x1fmeta\x1f${LABEL}\n"
done

[ -z "$ROFI_INPUT" ] && {
    notify-send "Clipboard" "No images could be decoded" --icon=dialog-error
    exit 1
}

# ── Show rofi ────────────────────────────────────────────────────
CHOICE=$(printf "%b" "$ROFI_INPUT" | rofi -dmenu \
    -p " " \
    -display-columns 1 \
    -config "$ROFI_CONFIG")

[ -z "$CHOICE" ] && exit 0

# ── Copy selected image ─────────────────────────────────────────
for LINE in "${IMG_LINES[@]}"; do
    CLIP_ID=$(echo "$LINE" | cut -f1)
    if [ "$CLIP_ID" = "$CHOICE" ]; then
        cliphist decode <<< "$LINE" | wl-copy
        notify-send "Clipboard" "Image copied to clipboard" --icon=edit-copy
        break
    fi
done
