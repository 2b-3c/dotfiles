step "Step 24 — SDDM login screen"

gum spin --spinner dot \
          --title "  Installing sddm-astronaut-theme..." \
          -- bash -c '
  ASTRONAUT_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
  sudo mkdir -p "$ASTRONAUT_DIR"
  sudo cp -r "'"$ONYX_DOTFILES"'/sddm/astronaut/"* "$ASTRONAUT_DIR/"
  sudo cp -r "$ASTRONAUT_DIR/Fonts/"* /usr/share/fonts/ 2>/dev/null || true
  printf "[Theme]\nCurrent=sddm-astronaut-theme\n" | sudo tee /etc/sddm.conf > /dev/null
  sudo mkdir -p /etc/sddm.conf.d
  printf "[General]\nInputMethod=qtvirtualkeyboard\n" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null
  sudo sed -i "s|^ConfigFile=.*|ConfigFile=Themes/sky_blue.conf|" "$ASTRONAUT_DIR/metadata.desktop"
' >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Installing SilentSDDM theme..." \
          -- bash -c '
  SILENT_DIR="/usr/share/sddm/themes/SilentSDDM"
  sudo mkdir -p "$SILENT_DIR"
  sudo cp -r "'"$ONYX_DOTFILES"'/sddm/silent/"* "$SILENT_DIR/"
  sudo sed -i "s|^ConfigFile=.*|ConfigFile=configs/sakura_pink.conf|" "$SILENT_DIR/metadata.desktop"
  sudo cp -r "$SILENT_DIR/fonts/"* /usr/share/fonts/ 2>/dev/null || true
  sudo systemctl enable sddm 2>/dev/null || true
' >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ SDDM configured and enabled"
