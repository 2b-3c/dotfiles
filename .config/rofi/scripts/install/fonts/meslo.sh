#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install MesloLGM Nerd Font Mono" bash -c "
    yay -S ttf-meslo-nerd --noconfirm
    fc-cache -f
    sed -i 's/^font_family .*/font_family      MesloLGM Nerd Font Mono/' "$HOME/.config/kitty/kitty.conf"
    notify-send 'Font' '✓ Installed: MesloLGM Nerd Font Mono'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
