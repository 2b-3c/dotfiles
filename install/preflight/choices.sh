step "Pre-install choices"

# Ask about GRUB before the long install so user doesn't wait
INSTALL_GRUB_THEME=false
gum confirm \
  --affirmative "Yes — install GRUB theme" \
  --negative    "No  — skip (not using GRUB)" \
  --padding "0 0 1 $PADDING_LEFT" \
  "  Install ONYX GRUB theme?" && INSTALL_GRUB_THEME=true || true

export INSTALL_GRUB_THEME
