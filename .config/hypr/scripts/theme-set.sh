#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   theme-set.sh — ONYX Theme Engine
#   مبني على نظام Omarchy: colors.toml + templates
#
#   Usage: theme-set.sh <theme_name>
#   Themes: void_purple · deep_cyan · sakura_pink · lavender · sky_blue · inferno
# ══════════════════════════════════════════════════════════════════

CFG="$HOME/.config"
THEMES_DIR="$CFG/themes"
TEMPLATES_DIR="$THEMES_DIR/templates"
SDDM_THEME_DIR="/usr/share/sddm/themes/silent"

# ── Resolve theme path ────────────────────────────────────────────
THEME="${1:-sky_blue}"

find_theme_dir() {
  local t="$1"
  local found
  found=$(find "$THEMES_DIR" -mindepth 2 -maxdepth 2 -type d -name "$t" 2>/dev/null | head -1)
  echo "$found"
}

THEME_DIR=$(find_theme_dir "$THEME")

if [[ -z $THEME_DIR || ! -f "$THEME_DIR/colors.toml" ]]; then
  echo "Error: Theme '$THEME' not found or missing colors.toml"
  echo "Available themes:"
  find "$THEMES_DIR" -name "colors.toml" | sed 's|.*/||;s|/colors.toml||' | sort
  exit 1
fi

COLORS_FILE="$THEME_DIR/colors.toml"

# ── Parse colors.toml ─────────────────────────────────────────────
parse_color() {
  local key="$1"
  grep -E "^${key}\s*=" "$COLORS_FILE" | head -1 | sed 's/.*=\s*"\(.*\)".*/\1/'
}

background=$(parse_color background)
foreground=$(parse_color foreground)
accent=$(parse_color accent)
accent2=$(parse_color accent2)
bg_alt=$(parse_color bg_alt)
bg_alt2=$(parse_color bg_alt2)
border=$(parse_color border)
fg_alt=$(parse_color fg_alt)
urgent=$(parse_color urgent)
selection_bg=$(parse_color selection_bg)
selection_fg=$(parse_color selection_fg)
color0=$(parse_color color0)
color1=$(parse_color color1)
color2=$(parse_color color2)
color3=$(parse_color color3)
color4=$(parse_color color4)
color5=$(parse_color color5)
color6=$(parse_color color6)
color7=$(parse_color color7)
color8=$(parse_color color8)
color9=$(parse_color color9)
color10=$(parse_color color10)
color11=$(parse_color color11)
color12=$(parse_color color12)
color13=$(parse_color color13)
color14=$(parse_color color14)
color15=$(parse_color color15)
hypr_active=$(parse_color hypr_active)
hypr_inactive=$(parse_color hypr_inactive)
shadow_color=$(parse_color shadow_color)
shadow_inactive=$(parse_color shadow_inactive)
gtk_theme=$(parse_color gtk_theme)
gtk_color_scheme=$(parse_color gtk_color_scheme)

# ── Icon theme: ملف icon-theme هو المصدر الوحيد ──────────────────
# (icon_theme في colors.toml مهمل — المصدر الموثوق هو ملف icon-theme)
if [[ -f "$THEME_DIR/icon-theme" ]]; then
  icon_theme=$(tr -d '[:space:]' < "$THEME_DIR/icon-theme")
else
  icon_theme="Yaru"  # fallback آمن
fi

# ── Fallback للأيقونات إن لم تكن مثبتة ───────────────────────────
if [[ -n "$icon_theme" && ! -d "/usr/share/icons/$icon_theme" ]]; then
  echo "⚠ Icon theme '$icon_theme' not found in /usr/share/icons/, falling back to Yaru"
  icon_theme="Yaru"
fi

echo "→ Applying theme: $THEME"

# ── Template engine ───────────────────────────────────────────────
# Replaces {{ key }} placeholders in a template file
apply_template() {
  local tpl="$1"
  local out="$2"

  sed \
    -e "s|{{ background }}|$background|g" \
    -e "s|{{ foreground }}|$foreground|g" \
    -e "s|{{ accent }}|$accent|g" \
    -e "s|{{ accent2 }}|$accent2|g" \
    -e "s|{{ bg_alt }}|$bg_alt|g" \
    -e "s|{{ bg_alt2 }}|$bg_alt2|g" \
    -e "s|{{ border }}|$border|g" \
    -e "s|{{ fg_alt }}|$fg_alt|g" \
    -e "s|{{ urgent }}|$urgent|g" \
    -e "s|{{ selection_bg }}|$selection_bg|g" \
    -e "s|{{ selection_fg }}|$selection_fg|g" \
    -e "s|{{ color0 }}|$color0|g" \
    -e "s|{{ color1 }}|$color1|g" \
    -e "s|{{ color2 }}|$color2|g" \
    -e "s|{{ color3 }}|$color3|g" \
    -e "s|{{ color4 }}|$color4|g" \
    -e "s|{{ color5 }}|$color5|g" \
    -e "s|{{ color6 }}|$color6|g" \
    -e "s|{{ color7 }}|$color7|g" \
    -e "s|{{ color8 }}|$color8|g" \
    -e "s|{{ color9 }}|$color9|g" \
    -e "s|{{ color10 }}|$color10|g" \
    -e "s|{{ color11 }}|$color11|g" \
    -e "s|{{ color12 }}|$color12|g" \
    -e "s|{{ color13 }}|$color13|g" \
    -e "s|{{ color14 }}|$color14|g" \
    -e "s|{{ color15 }}|$color15|g" \
    -e "s|{{ hypr_active }}|$hypr_active|g" \
    -e "s|{{ hypr_inactive }}|$hypr_inactive|g" \
    -e "s|{{ shadow_color }}|$shadow_color|g" \
    -e "s|{{ shadow_inactive }}|$shadow_inactive|g" \
    "$tpl" > "$out"
}

# ── Apply templates ───────────────────────────────────────────────

# Kitty
apply_template "$TEMPLATES_DIR/kitty.conf.tpl" "$CFG/kitty/theme.conf"
kill -SIGUSR1 $(pgrep kitty) 2>/dev/null || true

# Hyprland colors
apply_template "$TEMPLATES_DIR/hypr.conf.tpl" "$CFG/hypr/colors.conf"
hyprctl keyword general:col.active_border "$hypr_active" 2>/dev/null || true
hyprctl keyword general:col.inactive_border "$hypr_inactive" 2>/dev/null || true
hyprctl keyword decoration:shadow:color "$shadow_color" 2>/dev/null || true
hyprctl keyword decoration:shadow:color_inactive "$shadow_inactive" 2>/dev/null || true

# Waybar
apply_template "$TEMPLATES_DIR/waybar.css.tpl" "$CFG/waybar/theme.css"
pkill waybar 2>/dev/null
sleep 0.5
waybar &disown

# Rofi
apply_template "$TEMPLATES_DIR/rofi.rasi.tpl" "$CFG/rofi/themes/theme.rasi"

# SwayNC
apply_template "$TEMPLATES_DIR/swaync.css.tpl" "$CFG/swaync/theme.css"
swaync-client -rs 2>/dev/null || true

# btop
if [[ -f "$THEME_DIR/btop.theme" ]]; then
  cp "$THEME_DIR/btop.theme" "$CFG/btop/themes/theme.theme"
fi

# Starship
if [[ -f "$THEME_DIR/starship.toml" ]]; then
  cp "$THEME_DIR/starship.toml" "$CFG/starship.toml"
fi

# Yazi
if [[ -f "$THEME_DIR/yazi.toml" ]]; then
  cp "$THEME_DIR/yazi.toml" "$CFG/yazi/theme.toml"
fi

# Fastfetch
if [[ -f "$THEME_DIR/fastfetch.jsonc" ]]; then
  cp "$THEME_DIR/fastfetch.jsonc" "$CFG/fastfetch/config.jsonc"
fi

# GTK
if [[ -f "$THEME_DIR/gtk3.css" ]]; then
  cp "$THEME_DIR/gtk3.css" "$CFG/gtk-3.0/gtk.css"
  cp "$THEME_DIR/gtk4.css" "$CFG/gtk-4.0/gtk.css" 2>/dev/null || true
  cp "$THEME_DIR/gtk3.ini" "$CFG/gtk-3.0/settings.ini" 2>/dev/null || true
  cp "$THEME_DIR/gtk4.ini" "$CFG/gtk-4.0/settings.ini" 2>/dev/null || true
fi
gsettings set org.gnome.desktop.interface gtk-theme        "$gtk_theme"        2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme     "$gtk_color_scheme" 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme     "Bibata-Modern-Classic" 2>/dev/null || true
if [[ -n "$icon_theme" ]]; then
  gsettings set org.gnome.desktop.interface icon-theme "$icon_theme" 2>/dev/null || true
  sudo gtk-update-icon-cache "/usr/share/icons/$icon_theme" 2>/dev/null || true
fi

# ── cava — نسخ الملف مباشرة بدل بناء السطور يدوياً ───────────────
if [[ -f "$THEME_DIR/cava" ]]; then
  # احذف أي سطور gradient موجودة ثم أضف السطور الجديدة بعد [color]
  CAVA_CFG="$CFG/cava/config"
  # احذف السطور القديمة
  sed -i '/^gradient/d; /^gradient_color/d' "$CAVA_CFG" 2>/dev/null || true
  # اقرأ محتوى ملف cava من الثيم
  CAVA_COLORS=$(cat "$THEME_DIR/cava")
  # أضف بعد سطر [color] مباشرةً باستخدام python3 (أكثر موثوقية من sed متعدد الأسطر)
  python3 - "$CAVA_CFG" "$CAVA_COLORS" << 'PYEOF'
import sys

cfg_path = sys.argv[1]
new_colors = sys.argv[2]

with open(cfg_path, 'r') as f:
    lines = f.readlines()

out = []
for line in lines:
    out.append(line)
    if line.strip() == '[color]':
        out.append(new_colors + '\n')

with open(cfg_path, 'w') as f:
    f.writelines(out)
PYEOF
fi
pkill cava 2>/dev/null || true

# Wallpaper
WALL=$(find "$THEME_DIR" -maxdepth 1 -name "wallpaper.*" 2>/dev/null | head -1)
if [[ -n $WALL && -f $WALL ]]; then
  pgrep -x awww-daemon || { awww-daemon & sleep 0.5; }
  awww img "$WALL" \
    --transition-bezier .43,1.19,1,.4 \
    --transition-fps 60 \
    --transition-step 90 \
    --transition-type "grow" \
    --transition-duration 0.7 2>/dev/null || true
  echo "$WALL" > "$CFG/hypr/.current_wallpaper"
fi

# ── SDDM ─────────────────────────────────────────────────────────
# يحدّث ConfigFile في metadata.desktop لتغيير ثيم SDDM
if [[ -d "$SDDM_THEME_DIR" && -f "$SDDM_THEME_DIR/metadata.desktop" ]]; then
  # تحقق من وجود ملف config مطابق للثيم الحالي
  SDDM_CONF="$SDDM_THEME_DIR/configs/${THEME}.conf"
  if [[ -f "$SDDM_CONF" ]]; then
    sudo sed -i "s|^ConfigFile=.*|ConfigFile=configs/${THEME}.conf|" \
      "$SDDM_THEME_DIR/metadata.desktop" 2>/dev/null || true
    echo "  ✓ SDDM config → configs/${THEME}.conf"
  else
    # لا يوجد ملف config مخصص — ابحث عن أقرب ثيم متاح حسب النمط (dark/light)
    THEME_MODE=$(echo "$THEME_DIR" | grep -oE 'dark|light')
    FALLBACK_CONF=$(ls "$SDDM_THEME_DIR/configs/"*.conf 2>/dev/null | head -1)
    if [[ -n "$FALLBACK_CONF" ]]; then
      FALLBACK_NAME=$(basename "$FALLBACK_CONF")
      sudo sed -i "s|^ConfigFile=.*|ConfigFile=configs/${FALLBACK_NAME}|" \
        "$SDDM_THEME_DIR/metadata.desktop" 2>/dev/null || true
      echo "  ⚠ SDDM: no config for '$THEME', using fallback: $FALLBACK_NAME"
    else
      echo "  ⚠ SDDM: no configs found in $SDDM_THEME_DIR/configs/"
    fi
  fi
else
  echo "  ℹ SDDM theme dir not found at $SDDM_THEME_DIR, skipping"
fi

# ── Save current theme name ────────────────────────────────────────
mkdir -p "$CFG/omarchy/current"
echo "$THEME" > "$CFG/omarchy/current/theme.name"

# Run hook if exists
HOOK="$HOME/.config/onyx/hooks/theme-set"
[[ -f "$HOOK" ]] && bash "$HOOK" "$THEME"

notify-send "Theme" "Switched to $THEME" --icon=preferences-desktop-theme 2>/dev/null || true
echo "✓ Theme '$THEME' applied successfully!"
