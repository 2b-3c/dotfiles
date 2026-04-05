#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove php" bash -c "
    sudo pacman -Rns --noconfirm php php-fpm composer
    notify-send 'PHP' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
