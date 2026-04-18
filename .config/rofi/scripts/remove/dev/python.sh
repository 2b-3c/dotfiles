#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove python" bash -c "
    sudo pacman -Rns --noconfirm python python-pip
    notify-send 'Python' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
