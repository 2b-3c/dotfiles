#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install docker-db" bash -c "
    sudo pacman -S --noconfirm docker docker-compose
    sudo systemctl enable --now docker
    sudo usermod -aG docker $USER
    notify-send 'Docker DB' '✓ Log out and back in to activate docker group'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
