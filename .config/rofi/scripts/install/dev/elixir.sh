#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install elixir" bash -c "
    sudo pacman -S --noconfirm elixir
    notify-send 'Elixir' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
