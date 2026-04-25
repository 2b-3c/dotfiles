#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove ocaml" bash -c "
    sudo pacman -Rns --noconfirm ocaml opam
    notify-send 'OCaml' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
