#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Zed" bash -c "
    sudo pacman -S --noconfirm zed
    notify-send 'Zed' '✓ Installed successfully'
    zed &
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
