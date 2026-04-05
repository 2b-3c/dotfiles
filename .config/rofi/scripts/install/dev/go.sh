#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install go" bash -c "
    sudo pacman -S --noconfirm go
    notify-send 'Go' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
