#!/bin/bash

get_layout() {
    local layout=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null)
    case "$layout" in
        "English (US)") echo "󰌌 EN" ;;
        "Arabic")       echo "󰌌 AR" ;;
        *)              echo "󰌌 ??" ;;
    esac
}

if [ "$1" = "--switch" ]; then
    current=$(get_layout)
    case "$current" in
        *EN*)
            hyprctl keyword input:kb_layout "ara"
            notify-send -i input-keyboard "Keyboard Layout" "Arabic Layout" -t 1000
            ;;
        *)
            hyprctl keyword input:kb_layout "us"
            notify-send -i input-keyboard "Keyboard Layout" "US Layout" -t 1000
            ;;
    esac
    exit 0
fi

if [ "$1" = "--hyprlock" ]; then
    get_layout
    exit 0
fi

case $(get_layout) in
    *EN*) echo '{"text": "en", "tooltip": "US Layout"}' ;;
    *AR*) echo '{"text": "ar", "tooltip": "Arabic Layout"}' ;;
    *)    echo '{"text": "??", "tooltip": "Unknown Layout"}' ;;
esac
