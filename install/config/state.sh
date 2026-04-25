step "Step 21 — ONYX state files"

gum spin --spinner dot \
          --title "  Writing version and theme state..." \
          -- bash -c "
  mkdir -p '$HOME/.config/omarchy/current'
  echo '$ONYX_VERSION' > '$HOME/.config/omarchy/version'
  echo 'sky_blue'      > '$HOME/.config/omarchy/current/theme.name'
  mkdir -p '$HOME/.config/onyx/hooks'
  for sample in '$HOME/.config/onyx/hooks/'*.sample; do
    [[ -f \"\$sample\" ]] || continue
    dest=\"$HOME/.config/onyx/hooks/\$(basename \"\$sample\")\"
    [[ ! -f \"\$dest\" ]] && cp \"\$sample\" \"\$dest\"
  done
  mkdir -p '$HOME/.local/state/onyx/migrations'
" >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ State files written"
