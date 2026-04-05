#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove clojure" bash -c "
    sudo pacman -Rns --noconfirm clojure leiningen
    notify-send 'Clojure' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
