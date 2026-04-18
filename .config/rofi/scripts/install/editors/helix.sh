#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Helix" bash -c "
    sudo pacman -S --noconfirm helix
    notify-send 'Helix' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
