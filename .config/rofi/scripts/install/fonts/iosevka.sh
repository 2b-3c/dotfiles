#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Iosevka Nerd Font Mono" bash -c "
    yay -S ttf-iosevka-nerd --noconfirm
    fc-cache -f
    sed -i 's/^font_family .*/font_family      Iosevka Nerd Font Mono/' "$HOME/.config/kitty/kitty.conf"
    notify-send 'Font' '✓ Installed: Iosevka Nerd Font Mono'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
