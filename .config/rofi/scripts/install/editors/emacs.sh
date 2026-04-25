#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Emacs" bash -c "
    sudo pacman -S --noconfirm emacs
    systemctl --user enable --now emacs
    notify-send 'Emacs' '✓ Installed and activated'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
