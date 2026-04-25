#!/usr/bin/env bash
# Window switcher — counts windows and adjusts size automatically

ROFI_CONF="$HOME/.config/rofi"

# Current window count via hyprctl
count=$(hyprctl clients -j 2>/dev/null | python3 -c "
import sys, json
clients = json.load(sys.stdin)
print(len([c for c in clients if c.get('title','').strip()]))
" 2>/dev/null || echo 3)

# Max 8 lines, min 1
visible=$(( count > 8 ? 8 : count < 1 ? 1 : count ))

rofi -show window \
    -config "$ROFI_CONF/window-switcher.rasi" \
    -lines "$visible" \
    -theme-str "listview { lines: ${visible}; } window { width: 300px; }"
