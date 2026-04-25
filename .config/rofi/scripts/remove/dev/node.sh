#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove Node.js" bash -c "
    rm -rf $HOME/.nvm
    notify-send 'Node.js' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
