#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install ruby" bash -c "
    sudo pacman -S --noconfirm ruby rubygems
    gem install rails
    notify-send 'Ruby on Rails' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
