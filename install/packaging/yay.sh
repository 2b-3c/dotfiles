step "Step 1 — yay AUR helper"

if ! command -v yay &>/dev/null; then
  gum spin --spinner dot \
            --title "  Installing git and base-devel..." \
            -- bash -c "sudo pacman -S --needed --noconfirm git base-devel" \
    >> "$ONYX_LOG_FILE" 2>&1

  gum spin --spinner dot \
            --title "  Checking network connectivity..." \
            -- bash -c "curl -fsS --max-time 10 https://google.com > /dev/null" \
    >> "$ONYX_LOG_FILE" 2>&1 || {
    gum style --foreground 1 --padding "0 0 1 $PADDING_LEFT" \
      "  ✗ No internet connection detected."
    exit 1
  }

  gum spin --spinner dot \
            --title "  Building yay from AUR..." \
            -- bash -c '
    set -e
    _clone() {
      for i in 1 2 3; do rm -rf "$2"; git clone "$1" "$2" && return 0; sleep 3; done; return 1
    }
    if _clone "https://aur.archlinux.org/yay.git" /tmp/yay-build; then
      cd /tmp/yay-build && makepkg -si --noconfirm && cd / && rm -rf /tmp/yay-build
    elif _clone "https://github.com/Jguer/yay.git" /tmp/yay-build; then
      cd /tmp/yay-build && makepkg -si --noconfirm && cd / && rm -rf /tmp/yay-build
    else
      exit 1
    fi
  ' >> "$ONYX_LOG_FILE" 2>&1 || {
    gum style --foreground 1 --padding "0 0 1 $PADDING_LEFT" "  ✗ Failed to install yay."
    exit 1
  }
else
  gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ yay already installed"
fi

gum spin --spinner dot \
          --title "  Syncing package database..." \
          -- bash -c "sudo pacman -Syu --noconfirm" \
  >> "$ONYX_LOG_FILE" 2>&1

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ Package database up to date"
