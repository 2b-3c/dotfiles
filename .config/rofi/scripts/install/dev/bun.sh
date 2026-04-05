#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install bun" bash -c "
    curl -fsSL https://bun.sh/install | bash
    notify-send 'Bun' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
