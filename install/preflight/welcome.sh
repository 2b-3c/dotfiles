clear_logo

gum style \
  --foreground 6 \
  --padding "0 0 0 $PADDING_LEFT" \
  "  Hyprland dotfiles installer  ·  v${ONYX_VERSION}"
echo

gum style --padding "0 0 0 $PADDING_LEFT" \
  "  This will install and configure your full ONYX desktop:" \
  "" \
  "  Hyprland · Waybar · Kitty · Rofi · SwayNC · PipeWire" \
  "  Fonts · Cursors · ZSH · SDDM · GRUB theme · and more"
echo

gum confirm \
  --affirmative "Begin Installation" \
  --negative    "Cancel" \
  --padding "0 0 1 $PADDING_LEFT" \
  "" || {
  gum style --padding "1 0 1 $PADDING_LEFT" "  Installation cancelled."
  exit 0
}
