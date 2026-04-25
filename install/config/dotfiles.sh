step "Step 20 — Deploying dotfiles"

CONFIG_SRC="$ONYX_DOTFILES/.config"
CONFIG_DST="$HOME/.config"

if [[ ! -d "$CONFIG_SRC" ]]; then
  gum style --foreground 1 --padding "0 0 1 $PADDING_LEFT" \
    "  ✗ .config directory not found. Run this script from the dotfiles folder."
  exit 1
fi

# Backup existing configs silently
BACKUP="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"
backed_up=0
for d in hypr waybar kitty rofi swaync btop cava fastfetch zsh tmux; do
  [[ -d "$CONFIG_DST/$d" ]] && cp -r "$CONFIG_DST/$d" "$BACKUP/" && (( backed_up++ )) || true
done
(( backed_up == 0 )) && rmdir "$BACKUP" 2>/dev/null || true

gum spin --spinner dot \
          --title "  Copying config files..." \
          -- bash -c "cp -r '$CONFIG_SRC'/. '$CONFIG_DST/'" \
  >> "$ONYX_LOG_FILE" 2>&1

gum spin --spinner dot \
          --title "  Setting script permissions..." \
          -- bash -c "
  for dir in \
    '$CONFIG_DST/hypr/scripts' \
    '$CONFIG_DST/waybar/scripts' \
    '$CONFIG_DST/rofi/scripts' \
    '$CONFIG_DST/swaync/scripts' \
    '$CONFIG_DST/fastfetch/scripts'; do
    [[ -d \"\$dir\" ]] && find \"\$dir\" -type f \( -name '*.sh' -o -name '*.py' \) -exec chmod +x {} +
  done
" >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" \
  "  ✓ Dotfiles deployed → $CONFIG_DST"
