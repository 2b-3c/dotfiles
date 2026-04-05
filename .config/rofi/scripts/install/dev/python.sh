#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install python" bash -c "
    sudo pacman -S --noconfirm python python-pip
    notify-send 'Python' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
