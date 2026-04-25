step "Step 23 — Battery monitor"

CONFIG_DST="$HOME/.config"

if ls /sys/class/power_supply/BAT* &>/dev/null 2>&1; then
  gum spin --spinner dot \
            --title "  Enabling battery monitor timer..." \
            -- bash -c "
    cp '$CONFIG_DST/systemd/user/onyx-battery-monitor.service' '$HOME/.config/systemd/user/' 2>/dev/null || true
    cp '$CONFIG_DST/systemd/user/onyx-battery-monitor.timer'   '$HOME/.config/systemd/user/' 2>/dev/null || true
    systemctl --user daemon-reload
    systemctl --user enable --now onyx-battery-monitor.timer 2>/dev/null || true
  " >> "$ONYX_LOG_FILE" 2>&1
  gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ Battery monitor enabled"
else
  gum style --foreground 3 --padding "0 0 1 $PADDING_LEFT" \
    "  ─ No battery detected (desktop) — skipping"
  echo "Battery monitor skipped: no battery found" >> "$ONYX_LOG_FILE"
fi
