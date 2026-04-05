#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Crush" bash -c "
    yay -S crush-bin --noconfirm || go install github.com/charmbracelet/crush@latest
    notify-send 'Crush' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
