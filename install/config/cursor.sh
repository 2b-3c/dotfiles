step "Step 17 — Cursor theme"

gum spin --spinner dot \
          --title "  Activating Bibata-Modern-Classic cursor..." \
          -- bash -c '
  mkdir -p "$HOME/.icons/default"
  if [[ -d /usr/share/icons/Bibata-Modern-Classic ]]; then
    ln -sf /usr/share/icons/Bibata-Modern-Classic "$HOME/.icons/Bibata-Modern-Classic" 2>/dev/null || true
    printf "[Icon Theme]\nName=Default\nComment=Default Cursor Theme\nInherits=Bibata-Modern-Classic\n" \
      > "$HOME/.icons/default/index.theme"
    gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size  16 2>/dev/null || true
  fi
' >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" \
  "  ✓ Cursor set to Bibata-Modern-Classic (size 16)"
