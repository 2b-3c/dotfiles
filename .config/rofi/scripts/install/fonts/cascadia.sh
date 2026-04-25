#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install CaskaydiaMono Nerd Font Mono" bash -c "
    yay -S ttf-cascadia-mono-nerd --noconfirm
    fc-cache -f
    sed -i 's/^font_family .*/font_family      CaskaydiaMono Nerd Font Mono/' "$HOME/.config/kitty/kitty.conf"
    notify-send 'Font' '✓ Installed: CaskaydiaMono Nerd Font Mono'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
