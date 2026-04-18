#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Sublime Text" bash -c "
    yay -S sublime-text-4 --noconfirm
    notify-send 'Sublime Text' '✓ Installed successfully'
    subl &
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
