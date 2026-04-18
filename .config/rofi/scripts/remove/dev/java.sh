#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove java" bash -c "
    sudo pacman -Rns --noconfirm jdk-openjdk
    notify-send 'Java' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
