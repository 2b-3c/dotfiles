#!/usr/bin/env bash
kitty --class "popup" --title "popup:Remove symfony" bash -c "
    rm -f $HOME/.symfony5/bin/symfony
    notify-send 'Symfony' '✓ Removed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
