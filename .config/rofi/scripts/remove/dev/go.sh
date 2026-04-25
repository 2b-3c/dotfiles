#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove go" bash -c "
    sudo pacman -Rns --noconfirm go
    notify-send 'Go' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
