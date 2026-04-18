#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Dropbox" bash -c "
    yay -S dropbox --noconfirm
    systemctl --user enable --now dropbox
    notify-send 'Dropbox' '✓ Installed and started'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
