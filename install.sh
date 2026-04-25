#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#   ONYX Dotfiles Installer — Arch Linux
#   Hyprland · Waybar · Kitty · Rofi · SwayNC · and more
# ══════════════════════════════════════════════════════════════════

set -eEo pipefail

# ── Paths ─────────────────────────────────────────────────────────
export ONYX_DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export ONYX_INSTALL="$ONYX_DOTFILES/install"
export ONYX_LOG_FILE="/tmp/onyx-install.log"
export ONYX_VERSION="$(cat "$ONYX_DOTFILES/version" 2>/dev/null || echo "1.1.0")"

# ── Install ───────────────────────────────────────────────────────
source "$ONYX_INSTALL/helpers/all.sh"
source "$ONYX_INSTALL/preflight/all.sh"
source "$ONYX_INSTALL/packaging/all.sh"
source "$ONYX_INSTALL/config/all.sh"
source "$ONYX_INSTALL/post-install/all.sh"
