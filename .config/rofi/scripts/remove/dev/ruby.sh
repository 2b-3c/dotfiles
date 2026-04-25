#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove ruby" bash -c "
    sudo pacman -Rns --noconfirm ruby rubygems
    gem uninstall rails -a --force 2>/dev/null || true
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
