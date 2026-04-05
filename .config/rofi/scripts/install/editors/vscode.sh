#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install VSCode" bash -c "
    yay -S visual-studio-code-bin --noconfirm
    notify-send 'VSCode' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
