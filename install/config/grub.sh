step "Step 25 — GRUB theme"

if [[ "$INSTALL_GRUB_THEME" == "true" ]]; then
  gum spin --spinner dot \
            --title "  Installing onyx-grub theme..." \
            -- bash -c '
    set -e
    GRUB_SRC="'"$ONYX_DOTFILES"'/grub"
    if [[ -d /boot/grub ]]; then
      THEMES_DIR="/boot/grub/themes"; GRUB_CFG="/boot/grub/grub.cfg"
      MKCONFIG="$(command -v grub-mkconfig || echo grub-mkconfig)"
    elif [[ -d /boot/grub2 ]]; then
      THEMES_DIR="/boot/grub2/themes"; GRUB_CFG="/boot/grub2/grub.cfg"
      MKCONFIG="$(command -v grub2-mkconfig || echo grub2-mkconfig)"
    else
      echo "GRUB not found — skipping"
      exit 0
    fi
    sudo mkdir -p "$THEMES_DIR/onyx-grub"
    sudo cp -r "$GRUB_SRC"/. "$THEMES_DIR/onyx-grub/"
    sudo cp -an /etc/default/grub /etc/default/grub.bak
    sudo sed -i "/^GRUB_BACKGROUND=/d; /^GRUB_THEME=/d" /etc/default/grub
    echo "GRUB_THEME=\"$THEMES_DIR/onyx-grub/theme.txt\"" | sudo tee -a /etc/default/grub > /dev/null
    grep -q "^GRUB_TERMINAL_OUTPUT=" /etc/default/grub \
      && sudo sed -i "s/^GRUB_TERMINAL_OUTPUT=.*/GRUB_TERMINAL_OUTPUT=\"gfxterm\"/" /etc/default/grub \
      || echo "GRUB_TERMINAL_OUTPUT=\"gfxterm\"" | sudo tee -a /etc/default/grub > /dev/null
    command -v update-grub &>/dev/null \
      && sudo update-grub \
      || sudo "$MKCONFIG" -o "$GRUB_CFG"
  ' >> "$ONYX_LOG_FILE" 2>&1
  gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ onyx-grub theme installed"
else
  gum style --foreground 3 --padding "0 0 1 $PADDING_LEFT" "  ─ Skipped by user"
  echo "GRUB theme: skipped by user" >> "$ONYX_LOG_FILE"
fi
