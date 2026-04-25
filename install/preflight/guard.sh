abort_check() {
  gum style --foreground 1 --padding "0 0 0 $PADDING_LEFT" \
    "  ✗ Requirement not met: $1"
  echo
  gum confirm \
    --affirmative "Proceed anyway (unsupported)" \
    --negative    "Exit" \
    --padding "0 0 1 $PADDING_LEFT" \
    "" || exit 1
}

# Must be Arch Linux
[[ -f /etc/arch-release ]] || abort_check "Arch Linux not detected"

# Must not be a derivative
for marker in /etc/cachyos-release /etc/eos-release /etc/garuda-release /etc/manjaro-release; do
  if [[ -f $marker ]]; then
    abort_check "Vanilla Arch required (derivative detected)"
    break
  fi
done

# Must not be root
(( EUID != 0 )) || abort_check "Run as a regular user, not root"

# Must be x86_64
[[ $(uname -m) == "x86_64" ]] || abort_check "x86_64 CPU required"

gum style --foreground 2 --padding "0 0 1 $PADDING_LEFT" "  ✓ System checks passed"
echo "Guards: OK" >> "$ONYX_LOG_FILE"
