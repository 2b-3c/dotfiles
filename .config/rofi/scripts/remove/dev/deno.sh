#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove Deno" bash -c "
    rm -rf $HOME/.deno
    notify-send 'Deno' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
