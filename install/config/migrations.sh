step "Step 26 — Migrations"

CONFIG_DST="$HOME/.config"

gum spin --spinner dot \
          --title "  Running migrations..." \
          -- bash -c "bash '$CONFIG_DST/hypr/scripts/migrate.sh' || true" \
  >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ Migrations complete"
