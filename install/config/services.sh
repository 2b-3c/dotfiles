step "Step 18 — System services"

gum spin --spinner dot \
          --title "  Enabling NetworkManager..." \
          -- bash -c "sudo systemctl enable --now NetworkManager 2>/dev/null || true" \
  >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Enabling Bluetooth..." \
          -- bash -c "sudo systemctl enable --now bluetooth 2>/dev/null || true" \
  >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Enabling UPower & power profiles..." \
          -- bash -c "
  sudo systemctl enable --now upower 2>/dev/null || true
  sudo systemctl enable --now power-profiles-daemon 2>/dev/null || true
" >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Enabling PipeWire..." \
          -- bash -c "
  systemctl --user enable --now pipewire       2>/dev/null || true
  systemctl --user enable --now pipewire-pulse 2>/dev/null || true
  systemctl --user enable --now wireplumber    2>/dev/null || true
" >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ System services enabled"
