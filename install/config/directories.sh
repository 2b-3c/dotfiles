step "Step 19 — Creating directories"

gum spin --spinner dot \
          --title "  Creating required directories..." \
          -- bash -c '
  mkdir -p \
    "$HOME/Pictures/Screenshots" \
    "$HOME/Pictures/Wallpapers" \
    "$HOME/Videos" \
    "$HOME/.local/share/fonts" \
    "$HOME/.local/share/applications" \
    "$HOME/.local/bin" \
    "$HOME/.cache" \
    "$HOME/.trash"
' >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ Directories created"
