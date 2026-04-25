#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install scala" bash -c "
    sudo pacman -S --noconfirm scala sbt
    notify-send 'Scala' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
