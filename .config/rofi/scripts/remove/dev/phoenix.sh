#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove phoenix" bash -c "
    mix archive.uninstall phx_new 2>/dev/null || true
    notify-send 'Phoenix' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
