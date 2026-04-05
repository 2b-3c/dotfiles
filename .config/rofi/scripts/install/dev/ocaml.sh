#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install ocaml" bash -c "
    sudo pacman -S --noconfirm ocaml opam
    opam init -y
    notify-send 'OCaml' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
