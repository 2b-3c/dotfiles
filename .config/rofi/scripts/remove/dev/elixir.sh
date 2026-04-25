#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove elixir" bash -c "
    sudo pacman -Rns --noconfirm elixir
    notify-send 'Elixir' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
