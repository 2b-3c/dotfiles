#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Ollama" bash -c "
    curl -fsSL https://ollama.ai/install.sh | sh
    systemctl --user enable --now ollama 2>/dev/null || sudo systemctl enable --now ollama
    notify-send 'Ollama' '✓ Installed successfully'
    echo ''
    read -n1 -s -rp 'Press any key to close...'
"
