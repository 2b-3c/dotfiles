#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   debug.sh — ONYX Debug Info Collector
#   Collects system info to help diagnose problems.
#   Usage: debug.sh [--print]
# ══════════════════════════════════════════════════════════════════

PRINT_ONLY=false
[[ "$1" == "--print" ]] && PRINT_ONLY=true

LOG_FILE="/tmp/onyx-debug.log"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
ONYX_VERSION=$(cat "$DOTFILES_DIR/version" 2>/dev/null || echo "unknown")
CURRENT_THEME=$(cat "$HOME/.config/omarchy/current/theme.name" 2>/dev/null || echo "unknown")

cat > "$LOG_FILE" << LOGEOF
Date: $(date)
Hostname: $(hostname)
ONYX Version: $ONYX_VERSION
Current Theme: $CURRENT_THEME
Shell: $SHELL
Hyprland: $(hyprctl version 2>/dev/null | head -1 || echo "not running")

=========================================
SYSTEM INFORMATION
=========================================
$(inxi -Farz 2>/dev/null || uname -a)

=========================================
DMESG (errors/warnings)
=========================================
$(sudo dmesg -l err,warn 2>/dev/null | tail -50 || echo "(requires sudo)")

=========================================
JOURNALCTL (current boot, warnings+errors)
=========================================
$(journalctl -b -p 4..1 --no-pager 2>/dev/null | tail -100)

=========================================
INSTALLED PACKAGES (explicit)
=========================================
$(pacman -Qqe 2>/dev/null | sort)

=========================================
HYPRLAND ACTIVE WINDOWS
=========================================
$(hyprctl clients -j 2>/dev/null | jq -r '.[] | "\(.class) — \(.title)"' 2>/dev/null || echo "N/A")
LOGEOF

if [[ "$PRINT_ONLY" == "true" ]]; then
  cat "$LOG_FILE"
  exit 0
fi

echo "Debug log saved to: $LOG_FILE"
echo ""

OPTIONS=("View log" "Save in current directory")
if ping -c 1 -W 2 8.8.8.8 >/dev/null 2>&1; then
  OPTIONS=("Upload log (0x0.st, 24h)" "${OPTIONS[@]}")
fi

if command -v gum &>/dev/null; then
  ACTION=$(gum choose "${OPTIONS[@]}" --header "ONYX Debug Log")
else
  echo "Choose an action:"
  select ACTION in "${OPTIONS[@]}"; do break; done
fi

case "$ACTION" in
  "Upload log"*)
    echo "Uploading..."
    URL=$(curl -sF "file=@$LOG_FILE" -Fexpires=24 https://0x0.st)
    if [[ -n "$URL" ]]; then
      echo "✓ Uploaded: $URL"
      echo "$URL" | wl-copy 2>/dev/null && echo "(copied to clipboard)"
      notify-send "Debug log uploaded" "$URL" -u low -t 10000
    else
      echo "✗ Upload failed"
    fi
    ;;
  "View log")
    ${PAGER:-less} "$LOG_FILE"
    ;;
  "Save in current directory")
    cp "$LOG_FILE" "./onyx-debug.log"
    echo "✓ Saved to $(pwd)/onyx-debug.log"
    ;;
esac
