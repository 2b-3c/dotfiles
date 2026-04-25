# Shared package install helper — used by all packaging scripts
# Usage: _install "Label" pkg1 pkg2 ...
_install() {
  local label="$1"; shift
  gum spin --spinner dot \
            --title "  Installing $label..." \
            -- bash -c "yay -S --noconfirm --needed --noprogressbar $* 2>&1 || true" \
    >> "$ONYX_LOG_FILE" 2>&1
  gum style --foreground 2 --padding "0 0 0 $PADDING_LEFT" "  ✓ $label"
}
