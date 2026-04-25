#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   theme-select.sh — ONYX Theme Picker (Rofi UI)
#   يعرض الثيمات في Rofi ويستدعي theme-set.sh لتطبيقها
# ══════════════════════════════════════════════════════════════════

ROFI_CONF="$HOME/.config/rofi"
CFG="$HOME/.config"
THEMES_DIR="$CFG/themes"
THEME_SET="$CFG/hypr/scripts/theme-set.sh"

rofi_menu() {
  local input count
  input=$(cat)
  count=$(echo "$input" | grep -c .)
  echo "$input" | rofi -dmenu -no-custom \
    -config "$ROFI_CONF/launcher-menu.rasi" \
    -lines "$count" \
    -theme-str "listview { lines: ${count}; } window { width: 260px; }"
}

# ── Step 1: Category ──────────────────────────────────────────────
CATEGORY=$(printf '%s\n' "Dark" "Light" | rofi_menu)
[[ -z $CATEGORY ]] && exit 0

case "$CATEGORY" in
  "Dark")
    CHOICE=$(printf '%s\n' \
      "Void Purple" \
      "Deep Cyan" | rofi_menu)
    ;;
  "Light")
    CHOICE=$(printf '%s\n' \
      "Sakura Pink" \
      "Lavender" \
      "Sky Blue" \
      "Inferno" | rofi_menu)
    ;;
esac

[[ -z $CHOICE ]] && exit 0

# ── Step 2: Map display name → theme_name ─────────────────────────
case "$CHOICE" in
  "Void Purple") THEME="void_purple" ;;
  "Deep Cyan")   THEME="deep_cyan"   ;;
  "Sakura Pink") THEME="sakura_pink" ;;
  "Lavender")    THEME="lavender"    ;;
  "Sky Blue")    THEME="sky_blue"    ;;
  "Inferno")     THEME="inferno"     ;;
  *) exit 0 ;;
esac

# ── Step 3: Apply via engine ──────────────────────────────────────
bash "$THEME_SET" "$THEME"
