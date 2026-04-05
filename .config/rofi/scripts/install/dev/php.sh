#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install php" bash -c "
    sudo pacman -S --noconfirm php php-fpm composer
    notify-send 'PHP' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
