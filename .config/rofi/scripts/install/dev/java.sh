#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install java" bash -c "
    sudo pacman -S --noconfirm jdk-openjdk
    notify-send 'Java' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
