#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Tailscale" bash -c "
    sudo pacman -S tailscale --noconfirm
    sudo systemctl enable --now tailscaled
    sudo tailscale up
    notify-send 'Tailscale' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
