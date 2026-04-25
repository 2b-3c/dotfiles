step "Step 22 — Applying Sky Blue theme"

CONFIG_DST="$HOME/.config"

gum spin --spinner dot \
          --title "  Running theme-set.sh sky_blue..." \
          -- bash -c "
  chmod +x '$CONFIG_DST/hypr/scripts/theme-set.sh'
  bash '$CONFIG_DST/hypr/scripts/theme-set.sh' sky_blue
" >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Updating font cache..." \
          -- bash -c "fc-cache -f" \
  >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Applying GTK settings..." \
          -- bash -c "
  gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic' 2>/dev/null || true
  gsettings set org.gnome.desktop.interface cursor-size  16 2>/dev/null || true
  gsettings set org.gnome.desktop.interface font-name    'Noto Sans 11' 2>/dev/null || true
" >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ Sky Blue theme applied"
