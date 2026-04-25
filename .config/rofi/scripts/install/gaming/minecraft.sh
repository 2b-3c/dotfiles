#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Minecraft" bash -c "
    sudo pacman -S --noconfirm jdk-openjdk
    yay -S prismlauncher --noconfirm
    notify-send 'Minecraft' '✓ Installed successfully (Prism Launcher)'
    prismlauncher &
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
