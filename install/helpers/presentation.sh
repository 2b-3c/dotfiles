# ── Ensure gum is available ──────────────────────────────────────
if ! command -v gum &>/dev/null; then
  sudo pacman -S --noconfirm --needed gum 2>/dev/null || {
    command -v yay &>/dev/null && yay -S --noconfirm --needed gum
  }
fi

# ── Terminal dimensions ───────────────────────────────────────────
if [[ -e /dev/tty ]]; then
  TERM_SIZE=$(stty size 2>/dev/null </dev/tty)
  if [[ -n $TERM_SIZE ]]; then
    export TERM_HEIGHT=$(echo "$TERM_SIZE" | cut -d' ' -f1)
    export TERM_WIDTH=$(echo "$TERM_SIZE"  | cut -d' ' -f2)
  else
    export TERM_WIDTH=100; export TERM_HEIGHT=40
  fi
else
  export TERM_WIDTH=100; export TERM_HEIGHT=40
fi

export LOGO_PATH="$ONYX_DOTFILES/logo.txt"
export LOGO_WIDTH=$(awk '{ if (length > max) max = length } END { print max+0 }' "$LOGO_PATH" 2>/dev/null || echo 60)
export LOGO_HEIGHT=$(wc -l <"$LOGO_PATH" 2>/dev/null || echo 7)
export PADDING_LEFT=$(( (TERM_WIDTH - LOGO_WIDTH) / 2 ))
export PADDING_LEFT_SPACES=$(printf "%*s" $PADDING_LEFT "")
export PADDING="0 0 0 $PADDING_LEFT"

# ── gum theme (Sky Blue palette) ─────────────────────────────────
export GUM_CONFIRM_PROMPT_FOREGROUND="6"
export GUM_CONFIRM_SELECTED_FOREGROUND="0"
export GUM_CONFIRM_SELECTED_BACKGROUND="4"
export GUM_CONFIRM_UNSELECTED_FOREGROUND="7"
export GUM_CONFIRM_UNSELECTED_BACKGROUND="0"
export GUM_CHOOSE_PADDING="$PADDING"
export GUM_FILTER_PADDING="$PADDING"
export GUM_INPUT_PADDING="$PADDING"
export GUM_SPIN_PADDING="$PADDING"
export GUM_CONFIRM_PADDING="$PADDING"

clear_logo() {
  printf "\033[H\033[2J"
  gum style --foreground 4 --padding "1 0 0 $PADDING_LEFT" "$(<"$LOGO_PATH")"
}

step() {
  clear_logo
  gum style --foreground 6 --padding "0 0 1 $PADDING_LEFT" "  $1"
}
