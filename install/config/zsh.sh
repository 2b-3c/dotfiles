step "Step 16 — ZSH setup"

gum spin --spinner dot \
          --title "  Configuring ZSH as default shell..." \
          -- bash -c "
  ZSH_PATH=\"\$(command -v zsh)\"
  CURRENT_SHELL=\"\$(getent passwd '$USER' | cut -d: -f7)\"
  if [[ \"\$CURRENT_SHELL\" != \"\$ZSH_PATH\" ]]; then
    grep -q \"\$ZSH_PATH\" /etc/shells || echo \"\$ZSH_PATH\" | sudo tee -a /etc/shells > /dev/null
    chsh -s \"\$ZSH_PATH\"
  fi
  if [[ -d '$ONYX_DOTFILES/.config/zsh' ]]; then
    mkdir -p '$HOME/.config/zsh'
    cp -r '$ONYX_DOTFILES/.config/zsh'/. '$HOME/.config/zsh/'
  fi
  if [[ -f '$ONYX_DOTFILES/.zshrc' ]]; then
    [[ -f '$HOME/.zshrc' ]] && cp '$HOME/.zshrc' '$HOME/.zshrc.bak_\$(date +%Y%m%d_%H%M%S)'
    cp '$ONYX_DOTFILES/.zshrc' '$HOME/.zshrc'
  fi
" >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ ZSH configured"
