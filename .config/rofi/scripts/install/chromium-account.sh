#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Chromium" bash -c "
    sudo pacman -S chromium --noconfirm
    notify-send 'Chromium' '✓ Open the browser to add your account'
    chromium &
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
