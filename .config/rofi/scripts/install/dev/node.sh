#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install node" bash -c "
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm" && source "$NVM_DIR/nvm.sh"
    nvm install --lts
    notify-send 'Node.js' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
