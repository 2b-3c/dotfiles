#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install GeForce NOW" bash -c "
    yay -S geforcenow --noconfirm
    notify-send 'GeForce NOW' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
