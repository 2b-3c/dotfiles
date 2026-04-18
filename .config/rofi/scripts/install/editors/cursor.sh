#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Cursor" bash -c "
    yay -S cursor-bin --noconfirm
    notify-send 'Cursor' '✓ Installed successfully'
    cursor &
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
