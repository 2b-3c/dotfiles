#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Bitwarden" bash -c "
    yay -S bitwarden --noconfirm
    notify-send 'Bitwarden' '✓ Installed successfully'
    bitwarden &
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
