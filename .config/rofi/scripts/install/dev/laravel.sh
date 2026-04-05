#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install laravel" bash -c "
    sudo pacman -S --noconfirm php composer
    composer global require laravel/installer
    notify-send 'Laravel' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
