#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Ghostty" bash -c "
    yay -S ghostty --noconfirm
    notify-send 'Ghostty' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
