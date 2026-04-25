#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove zig" bash -c "
    sudo pacman -Rns --noconfirm zig
    notify-send 'Zig' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
