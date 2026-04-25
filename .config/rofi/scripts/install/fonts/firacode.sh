#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install FiraCode Nerd Font Mono" bash -c "
    yay -S ttf-firacode-nerd --noconfirm
    fc-cache -f
    sed -i 's/^font_family .*/font_family      FiraCode Nerd Font Mono/' "$HOME/.config/kitty/kitty.conf"
    notify-send 'Font' '✓ Installed: FiraCode Nerd Font Mono'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
