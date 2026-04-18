#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install zig" bash -c "
    sudo pacman -S --noconfirm zig
    notify-send 'Zig' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
