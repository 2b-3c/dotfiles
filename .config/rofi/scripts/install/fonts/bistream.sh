#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Bitstream Vera Sans Mono" bash -c "
    yay -S ttf-bitstream-vera --noconfirm
    fc-cache -f
    sed -i 's/^font_family .*/font_family      Bitstream Vera Sans Mono/' "$HOME/.config/kitty/kitty.conf"
    notify-send 'Font' '✓ Installed: Bitstream Vera Sans Mono'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
