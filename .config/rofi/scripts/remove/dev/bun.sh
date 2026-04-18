#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove Bun" bash -c "
    rm -rf $HOME/.bun
    notify-send 'Bun' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
