stop_install_log

# Kill sudo keepalive
kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true

echo_in_style() {
  echo "$1" | tte --canvas-width 0 --anchor-text c --frame-rate 640 print
}

clear
echo
tte -i "$ONYX_DOTFILES/logo.txt" --canvas-width 0 --anchor-text c --frame-rate 920 laseretch
echo

# Display installation duration
if [[ -n ${ONYX_INSTALL_DURATION:-} ]]; then
  echo_in_style "Installed in $ONYX_INSTALL_DURATION"
else
  echo_in_style "Finished installing"
fi

echo
gum style --foreground 6 --padding "0 0 0 $PADDING_LEFT" \
  "  Things you may want to configure manually:"
gum style --padding "0 0 0 $(( PADDING_LEFT + 2 ))" \
  "  ~/.config/hypr/monitors.conf   → Monitor name / resolution" \
  "  ~/.config/hypr/input.conf      → Keyboard layout, touchpad" \
  "  ~/Pictures/Wallpapers/         → Add your own wallpapers" \
  "  ~/.zshrc                       → Customize your shell" \
  "  ~/.config/onyx/hooks/          → User hooks (battery, theme)"

echo
gum style --foreground 6 --padding "0 0 0 $PADDING_LEFT" \
  "  Quick start:"
gum style --padding "0 0 1 $(( PADDING_LEFT + 2 ))" \
  "  Super + Space   → Main menu" \
  "  Super + I       → Wallpaper selector" \
  "  Super + T       → Terminal" \
  "  Full log        → $ONYX_LOG_FILE"
echo

gum confirm \
  --affirmative "Reboot Now" \
  --negative    "Exit" \
  --default \
  --show-help=false \
  --padding "0 0 1 $(( PADDING_LEFT + 24 ))" \
  "" && sudo reboot || {
  show_cursor
  gum style --foreground 2 --padding "1 0 1 $PADDING_LEFT" \
    "  Done! Run 'Hyprland' to start when ready."
}
