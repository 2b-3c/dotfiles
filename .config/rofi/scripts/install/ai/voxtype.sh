#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Dictation (voxtype)" bash -c "
    yay -S voxtype --noconfirm || pip install openai-whisper --break-system-packages
    notify-send 'Dictation' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
