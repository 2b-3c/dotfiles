#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove rust" bash -c "
    rustup self uninstall -y
    notify-send 'Rust' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
