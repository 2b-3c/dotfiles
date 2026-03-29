#!/usr/bin/env bash

ROFI_CONF="$HOME/.config/rofi"
SCRIPTS="$ROFI_CONF/scripts"

rofi_menu() {
    rofi -dmenu -no-custom -config "$ROFI_CONF/launcher-menu.rasi"
}

# ── القائمة الرئيسية ─────────────────────────────────────────────
show_main() {
    printf '%s\n' \
        "󰕰   Apps" \
        "󰄠   Install" \
        "󰗼   Remove" \
        "󰑓   Update" \
        "󰹉   Wallpaper" \
        "󰏘   Style" \
        "󰋑   About" \
        "⏻   System" \
    | rofi_menu
}

# ── Apps ─────────────────────────────────────────────────────────
menu_apps() {
    pkill rofi
    rofi -show drun -config "$ROFI_CONF/app-launcher.rasi"
}

# ── Install ──────────────────────────────────────────────────────
menu_install() {
    CHOICE=$(printf '%s\n' \
        "  Pacman repos" \
        "  AUR" \
    | rofi_menu)
    case "$CHOICE" in
        *Pacman*) kitty --title "󰄠 Install — Pacman" bash "$SCRIPTS/pacman-installer.sh" ;;
        *AUR*)    kitty --title "󰄠 Install — AUR"    bash "$SCRIPTS/aur-installer.sh" ;;
    esac
}

# ── Remove ───────────────────────────────────────────────────────
menu_remove() {
    CHOICE=$(printf '%s\n' \
        "Remove package" \
        "Remove with dependencies" \
        "Remove orphans" \
    | rofi_menu)
    case "$CHOICE" in
        "Remove package")           kitty --title "󰗼 Remove Package"  bash "$SCRIPTS/pkg-remove-tui.sh" remove ;;
        "Remove with dependencies") kitty --title "󰗼 Remove + Deps"   bash "$SCRIPTS/pkg-remove-tui.sh" deps ;;
        "Remove orphans")           kitty --title "󰁁 Remove Orphans"  bash "$SCRIPTS/pkg-remove-tui.sh" orphans ;;
    esac
}

# ── Update ───────────────────────────────────────────────────────
menu_update() {
    CHOICE=$(printf '%s\n' \
        "Update all" \
        "Update system only" \
        "Update AUR only" \
        "Select packages" \
        "Check updates" \
    | rofi_menu)
    case "$CHOICE" in
        "Update all")        kitty --title "󰑓 Update All"      bash "$SCRIPTS/pkg-update-tui.sh" all ;;
        "Update system only") kitty --title "󰑓 Update System"  bash "$SCRIPTS/pkg-update-tui.sh" system ;;
        "Update AUR only")   kitty --title "󰑓 Update AUR"      bash "$SCRIPTS/pkg-update-tui.sh" aur ;;
        "Select packages")   kitty --title "󰋼 Select Updates"  bash "$SCRIPTS/pkg-update-tui.sh" select ;;
        "Check updates")     kitty --title "󰭸 Check Updates"   bash "$SCRIPTS/pkg-update-tui.sh" check ;;
    esac
}

# ── Wallpaper ────────────────────────────────────────────────────
menu_wallpaper() {
    bash "$SCRIPTS/wallpaper-select.sh"
}

# ── Style ────────────────────────────────────────────────────────
menu_style() {
    CHOICE=$(printf '%s\n' \
        "Themes" \
        "SDDM Theme" \
    | rofi_menu)
    case "$CHOICE" in
        *Themes) bash "$SCRIPTS/theme-select.sh" ;;
        *SDDM*)  bash "$SCRIPTS/sddm-theme.sh" ;;
    esac
}

# ── About ────────────────────────────────────────────────────────
menu_about() {
    OS=$(grep "^PRETTY_NAME" /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
    KERNEL=$(uname -r)
    UPTIME=$(uptime -p 2>/dev/null | sed 's/up //')
    CPU=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d: -f2 | xargs)
    MEM_USED=$(free -h 2>/dev/null | awk '/^Mem:/{print $3}')
    MEM_TOTAL=$(free -h 2>/dev/null | awk '/^Mem:/{print $2}')
    DISK=$(df -h / 2>/dev/null | awk 'NR==2{print $3"/"$2}')
    printf '%s\n' \
        "  OS      →  $OS" \
        "  Kernel  →  $KERNEL" \
        "  WM      →  Hyprland" \
        "  Shell   →  $(basename "$SHELL")" \
        "  Uptime  →  $UPTIME" \
        "  CPU     →  $CPU" \
        "  RAM     →  $MEM_USED / $MEM_TOTAL" \
        "  Disk    →  $DISK" \
    | rofi -dmenu -no-custom -config "$ROFI_CONF/launcher-menu.rasi"
}

# ── System ───────────────────────────────────────────────────────
menu_system() {
    ACTION=$(printf '%s\n' \
        "󰌾   Lock" \
        "󰍃   Logout" \
        "󰒲   Suspend" \
        "󰜉   Reboot" \
        "󰐥   Shutdown" \
    | rofi_menu)
    case "$ACTION" in
        *Lock)     loginctl lock-session ;;
        *Logout)   hyprctl dispatch exit ;;
        *Suspend)  systemctl suspend ;;
        *Reboot)   systemctl reboot ;;
        *Shutdown) systemctl poweroff ;;
    esac
}

# ── Main ─────────────────────────────────────────────────────────
chosen=$(show_main)
[ -z "$chosen" ] && exit 0

case "$chosen" in
    *Apps)      menu_apps ;;
    *Install)   menu_install ;;
    *Remove)    menu_remove ;;
    *Update)    menu_update ;;
    *Wallpaper) menu_wallpaper ;;
    *Style)     menu_style ;;
    *About)     menu_about ;;
    *System)    menu_system ;;
esac
