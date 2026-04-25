#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove scala" bash -c "
    sudo pacman -Rns --noconfirm scala sbt
    notify-send 'Scala' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
