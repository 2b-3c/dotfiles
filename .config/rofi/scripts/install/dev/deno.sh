#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install deno" bash -c "
    curl -fsSL https://deno.land/install.sh | sh
    notify-send 'Deno' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
