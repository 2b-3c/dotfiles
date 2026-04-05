#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install rust" bash -c "
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    notify-send 'Rust' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
