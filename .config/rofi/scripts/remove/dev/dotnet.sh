#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove dotnet" bash -c "
    sudo pacman -Rns --noconfirm dotnet-sdk
    notify-send '.NET' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
