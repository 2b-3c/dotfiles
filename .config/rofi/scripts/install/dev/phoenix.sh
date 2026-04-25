#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install phoenix" bash -c "
    sudo pacman -S --noconfirm elixir
    mix local.hex --force
    mix archive.install hex phx_new --force
    notify-send 'Phoenix' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
