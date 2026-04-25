#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install dotnet" bash -c "
    sudo pacman -S --noconfirm dotnet-sdk
    notify-send '.NET' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
