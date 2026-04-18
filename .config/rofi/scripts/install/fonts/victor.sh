#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install VictorMono Nerd Font Mono" bash -c "
    yay -S ttf-victor-mono-nerd --noconfirm
    fc-cache -f
    sed -i 's/^font_family .*/font_family      VictorMono Nerd Font Mono/' "$HOME/.config/kitty/kitty.conf"
    notify-send 'Font' '✓ Installed: VictorMono Nerd Font Mono'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
