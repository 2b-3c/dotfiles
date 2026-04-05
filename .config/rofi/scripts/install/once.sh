#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install ONCE" bash -c "
    yay -S once --noconfirm
    notify-send 'ONCE' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
