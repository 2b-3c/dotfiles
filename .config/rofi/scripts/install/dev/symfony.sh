#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install symfony" bash -c "
    sudo pacman -S --noconfirm php composer
    curl -sS https://get.symfony.com/cli/installer | bash
    notify-send 'Symfony' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
