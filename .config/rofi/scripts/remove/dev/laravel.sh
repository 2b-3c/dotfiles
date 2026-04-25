#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove laravel" bash -c "
    composer global remove laravel/installer
    notify-send 'Laravel' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
