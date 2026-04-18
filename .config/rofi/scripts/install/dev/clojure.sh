#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install clojure" bash -c "
    sudo pacman -S --noconfirm clojure leiningen
    notify-send 'Clojure' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
