#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install LM Studio" bash -c "
    yay -S lm-studio --noconfirm
    notify-send 'LM Studio' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
