#!/usr/bin/env bash
# ══════════════════════════════════════════════════════════════════
#   DOTFILES INSTALLER — Arch Linux
#   Installs all packages, creates directories, deploys dotfiles,
#   and sets script permissions
# ══════════════════════════════════════════════════════════════════

set -euo pipefail

# ── Colors ───────────────────────────────────────────────────────
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
CYN='\033[0;36m'
MAG='\033[0;35m'
WHT='\033[1;37m'
DIM='\033[1;30m'
BLD='\033[1m'
NC='\033[0m'

banner() {
    clear
    echo -e "${CYN}${BLD}"
    echo "    ██╗  ██╗██╗   ██╗██████╗ ██████╗ ██╗      █████╗ ███╗   ██╗██████╗ "
    echo "    ██║  ██║╚██╗ ██╔╝██╔══██╗██╔══██╗██║     ██╔══██╗████╗  ██║██╔══██╗"
    echo "    ███████║ ╚████╔╝ ██████╔╝██████╔╝██║     ███████║██╔██╗ ██║██║  ██║"
    echo "    ██╔══██║  ╚██╔╝  ██╔═══╝ ██╔══██╗██║     ██╔══██║██║╚██╗██║██║  ██║"
    echo "    ██║  ██║   ██║   ██║     ██║  ██║███████╗██║  ██║██║ ╚████║██████╔╝"
    echo "    ╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═════╝"
    echo -e "              ${MAG}⚡ DOTFILES INSTALLER ⚡${NC}"
    echo -e "${DIM}════════════════════════════════════════════════════════════${NC}\n"
}

sep()  { echo -e "${DIM}────────────────────────────────────────────────────────────${NC}"; }
info() { echo -e "${CYN}  →  ${WHT}$*${NC}"; }
ok()   { echo -e "${GRN}  ✓  ${WHT}$*${NC}"; }
warn() { echo -e "${YLW}  ⚠  ${WHT}$*${NC}"; }
err()  { echo -e "${RED}  ✗  ${WHT}$*${NC}"; }
step() { echo -e "\n${CYN}${BLD}[ $* ]${NC}"; sep; }

# ── Install function ─────────────────────────────────────────────
install_pkgs() {
    local label="$1"; shift
    info "Installing: $label"
    if yay -S --noconfirm --needed --noprogressbar "$@" 2>/dev/null; then
        ok "$label"
        return 0
    fi
    local failed=0
    for pkg in "$@"; do
        yay -S --noconfirm --needed --noprogressbar "$pkg" 2>/dev/null \
            && ok "$pkg" \
            || { warn "Skipped: $pkg"; (( failed++ )) || true; }
    done
    return 0
}

# ══════════════════════════════════════════════════════════════════
banner

# ── Verify Arch Linux ────────────────────────────────────────────
if [[ ! -f /etc/arch-release ]]; then
    err "This installer is for Arch Linux only."
    exit 1
fi
sudo -v || { err "sudo required"; exit 1; }

# ── Install yay if not present ───────────────────────────────────
step "Prerequisites — yay (AUR helper)"

if ! command -v yay &>/dev/null; then
    info "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay-build
    cd /tmp/yay-build && makepkg -si --noconfirm && cd - && rm -rf /tmp/yay-build
    ok "yay installed"
else
    ok "yay already installed"
fi

info "Syncing package database..."
sudo pacman -Syu --noconfirm &>/dev/null
ok "Database synced"

# ══════════════════════════════════════════════════════════════════
# 1 — Hyprland
# ══════════════════════════════════════════════════════════════════
step "1 — Hyprland (window manager)"

install_pkgs "Hyprland core" \
    hyprland \
    hyprpaper \
    awww \
    hyprlock \
    hypridle \
    hyprsunset \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    xorg-xwayland

install_pkgs "Polkit agent" \
    polkit-gnome

# ══════════════════════════════════════════════════════════════════
# 2 — Terminal & Core Apps
# ══════════════════════════════════════════════════════════════════
step "2 — Terminal & Core Applications"

install_pkgs "Terminal + Browser + Files" \
    kitty \
    firefox \
    nautilus

# ══════════════════════════════════════════════════════════════════
# 3 — Rofi
# ══════════════════════════════════════════════════════════════════
step "3 — Rofi (launcher)"

install_pkgs "Rofi + plugins" \
    rofi-wayland \
    rofi-emoji

# ══════════════════════════════════════════════════════════════════
# 4 — Clipboard
# ══════════════════════════════════════════════════════════════════
step "4 — Clipboard"

install_pkgs "cliphist + wl-clipboard (Wayland clipboard manager)" \
    cliphist \
    wl-clipboard

# ══════════════════════════════════════════════════════════════════
# 5 — Waybar
# ══════════════════════════════════════════════════════════════════
step "5 — Waybar (status bar)"

install_pkgs "Waybar + Python deps" \
    waybar \
    python \
    python-requests \
    python-gobject \
    pacman-contrib

# ══════════════════════════════════════════════════════════════════
# 6 — Notification Center
# ══════════════════════════════════════════════════════════════════
step "6 — Sway Notification Center (swaync)"

install_pkgs "swaync" \
    swaync

# ══════════════════════════════════════════════════════════════════
# 7 — Audio
# ══════════════════════════════════════════════════════════════════
step "7 — Audio"

install_pkgs "PipeWire audio stack" \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    pamixer \
    playerctl \
    libpulse

# ══════════════════════════════════════════════════════════════════
# 8 — Network & Bluetooth
# ══════════════════════════════════════════════════════════════════
step "8 — Network & Bluetooth"

install_pkgs "NetworkManager + Bluetooth" \
    networkmanager \
    network-manager-applet \
    bluez \
    bluez-utils \
    rfkill

# ══════════════════════════════════════════════════════════════════
# 9 — Screenshot & Wayland utilities
# ══════════════════════════════════════════════════════════════════
step "9 — Screenshot & Wayland utilities"

install_pkgs "Screenshot + clipboard tools" \
    hyprshot \
    grim \
    slurp \
    wl-clipboard

# ══════════════════════════════════════════════════════════════════
# 10 — Brightness & Notifications
# ══════════════════════════════════════════════════════════════════
step "10 — Brightness & libnotify"

install_pkgs "brightnessctl + libnotify" \
    brightnessctl \
    libnotify

# ══════════════════════════════════════════════════════════════════
# 11 — System Info & Monitoring
# ══════════════════════════════════════════════════════════════════
step "11 — System Info & Monitoring"

install_pkgs "btop + fastfetch + cava + gum" \
    btop \
    fastfetch \
    cava \
    gum

# ══════════════════════════════════════════════════════════════════
# 12 — Fonts
# ══════════════════════════════════════════════════════════════════
step "12 — Fonts"

install_pkgs "Nerd Fonts" \
    ttf-firacode-nerd \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    noto-fonts-emoji

install_pkgs "Icons & Cursor" \
    papirus-icon-theme \
    bibata-cursor-theme

install_pkgs "Shell utilities" \
    fzf \
    zoxide \
    starship \
    zsh \
    lsd \
    bat \
    neovim \
    lf \
    ctpv \
    rsync \
    fd \
    ripgrep \
    p7zip \
    ffmpeg \
    hypridle \
    ffmpegthumbnailer \
    perl-image-exiftool

# ══════════════════════════════════════════════════════════════════
# 13.5 — Setup ZSH
# ══════════════════════════════════════════════════════════════════
step "13.5 — Setup ZSH as default shell"

# تعيين zsh كـ shell افتراضي
if [[ "$SHELL" != "$(which zsh)" ]]; then
    sudo usermod -s "$(which zsh)" "$USER"
    ok "ZSH set as default shell"
else
    ok "ZSH is already the default shell"
fi

# نسخ .zshrc
DOTFILES_DIR_EARLY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ -f "$DOTFILES_DIR_EARLY/.zshrc" ]]; then
    cp "$DOTFILES_DIR_EARLY/.zshrc" "$HOME/.zshrc"
    ok ".zshrc deployed"
fi

# ── Bibata cursor ──────────────────────────────────────────────────
step "13.1 — Activate Bibata Cursor"

info "Activating Bibata-Modern-Classic cursor..."
mkdir -p "$HOME/.icons/default"

if [ -d /usr/share/icons/Bibata-Modern-Classic ]; then
    ln -sf /usr/share/icons/Bibata-Modern-Classic "$HOME/.icons/Bibata-Modern-Classic" 2>/dev/null || true
    cat > "$HOME/.icons/default/index.theme" << 'ICONEOF'
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Bibata-Modern-Classic
ICONEOF
    gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic" 2>/dev/null || true
    gsettings set org.gnome.desktop.interface cursor-size  16                       2>/dev/null || true
    hyprctl setcursor Bibata-Modern-Classic 16 &>/dev/null || true
    ok "Cursor set to Bibata-Modern-Classic (size 16)"
else
    warn "Bibata-Modern-Classic not found — will apply after reboot"
fi

# ══════════════════════════════════════════════════════════════════
# 14 — Enable Services
# ══════════════════════════════════════════════════════════════════
step "14 — Enable System Services"

info "Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager 2>/dev/null && ok "NetworkManager" || warn "NetworkManager skipped"

info "Enabling Bluetooth..."
sudo systemctl enable --now bluetooth 2>/dev/null && ok "bluetooth" || warn "Bluetooth skipped"

info "Enabling PipeWire (user services)..."
systemctl --user enable --now pipewire       2>/dev/null && ok "pipewire"       || warn "pipewire skipped"
systemctl --user enable --now pipewire-pulse 2>/dev/null && ok "pipewire-pulse" || warn "pipewire-pulse skipped"
systemctl --user enable --now wireplumber    2>/dev/null && ok "wireplumber"    || warn "wireplumber skipped"

# ══════════════════════════════════════════════════════════════════
# 15 — Create Required Directories
# ══════════════════════════════════════════════════════════════════
step "15 — Create Required Directories"

DIRS=(
    "$HOME/.config"
    "$HOME/Pictures/Screenshots"
    "$HOME/Pictures/Wallpapers"
    "$HOME/Wallpapers/Pictures"
    "$HOME/.local/share/fonts"
    "$HOME/.local/bin"
    "$HOME/.trash"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    ok "Created: $dir"
done

# ══════════════════════════════════════════════════════════════════
# 16 — Deploy Dotfiles
# ══════════════════════════════════════════════════════════════════
step "16 — Deploy Dotfiles"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_SRC="$DOTFILES_DIR/.config"
CONFIG_DST="$HOME/.config"

if [[ ! -d "$CONFIG_SRC" ]]; then
    err ".config directory not found — run this script from the dotfiles folder"
    exit 1
fi

# Backup existing configs
BACKUP="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

COMPONENTS=(hypr waybar kitty rofi swaync btop cava fastfetch zsh)
backed_up=0

for d in "${COMPONENTS[@]}"; do
    if [[ -d "$CONFIG_DST/$d" ]]; then
        cp -r "$CONFIG_DST/$d" "$BACKUP/"
        info "Backed up: $d"
        (( backed_up++ )) || true
    fi
done

if (( backed_up > 0 )); then
    ok "Backup saved → $BACKUP"
else
    info "No existing configs to back up"
    rmdir "$BACKUP" 2>/dev/null || true
fi

# Copy dotfiles
cp -r "$CONFIG_SRC"/. "$CONFIG_DST/"
ok "Dotfiles deployed → $CONFIG_DST"

# Copy theme wallpapers
mkdir -p "$HOME/Pictures/Wallpapers"
cp -r "$DOTFILES_DIR/wallpapers/themes" "$HOME/Pictures/Wallpapers/" 2>/dev/null || true

# ══════════════════════════════════════════════════════════════════
# Apply Gruvbox Light as default theme
# ══════════════════════════════════════════════════════════════════
step "16.1 — Apply Gruvbox Light Theme"

# Waybar
cp "$CONFIG_DST/waybar/themes/gruvbox-light.css"        "$CONFIG_DST/waybar/theme.css"
ok "Waybar theme → Gruvbox Light"

# Kitty
cp "$CONFIG_DST/kitty/themes/gruvbox-light.conf"        "$CONFIG_DST/kitty/theme.conf"
ok "Kitty theme → Gruvbox Light"

# Rofi
cp "$CONFIG_DST/rofi/themes/gruvbox-light.rasi"         "$CONFIG_DST/rofi/themes/theme.rasi"
ok "Rofi theme → Gruvbox Light"

# SwayNC
cp "$CONFIG_DST/swaync/themes/gruvbox-light.css"        "$CONFIG_DST/swaync/theme.css"
ok "SwayNC theme → Gruvbox Light"

# btop
cp "$CONFIG_DST/btop/themes/gruvbox-light.theme"        "$CONFIG_DST/btop/themes/theme.theme"
ok "btop theme → Gruvbox Light"

# cava
sed -i '/^gradient_color/d' "$CONFIG_DST/cava/config"
sed -i "/^\[color\]/a gradient_color_3 = '#514f49'\ngradient_color_2 = '#6f6959'\ngradient_color_1 = '#958b73'" "$CONFIG_DST/cava/config"
ok "cava theme → Gruvbox Light"

# Wallpaper — حفظ المسار ليُستعاد عند أول تشغيل
GRUVBOX_WALL="$HOME/Pictures/Wallpapers/themes/gruvbox-light.png"
echo "$GRUVBOX_WALL" > "$CONFIG_DST/hypr/.current_wallpaper"
ok "Default wallpaper → Gruvbox Light"

# ══════════════════════════════════════════════════════════════════
# 17 — Set Script Permissions
# ══════════════════════════════════════════════════════════════════
step "17 — Set Script Permissions"

SCRIPT_DIRS=(
    "$CONFIG_DST/waybar/scripts"
    "$CONFIG_DST/rofi/scripts"
    "$CONFIG_DST/swaync/scripts"
    "$CONFIG_DST/hypr/scripts"
    "$CONFIG_DST/lf/previewer"
)

for dir in "${SCRIPT_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        find "$dir" -type f -name "*.sh" -exec chmod +x {} +
        find "$dir" -type f -name "*.py" -exec chmod +x {} +
        find "$dir" -type f ! -name "*.*" -exec chmod +x {} + 2>/dev/null || true
        ok "chmod +x → $dir"
    fi
done

# ══════════════════════════════════════════════════════════════════
# 18 — SDDM & sddm-astronaut-theme
# ══════════════════════════════════════════════════════════════════
step "18 — SDDM Display Manager & Theme"

install_pkgs "SDDM + Qt6 dependencies" \
    sddm \
    qt6-svg \
    qt6-virtualkeyboard \
    qt6-multimedia-ffmpeg

# Copy theme from dotfiles
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info "Installing sddm-astronaut-theme from dotfiles..."
sudo mkdir -p "$SDDM_THEME_DIR"
sudo cp -r "$DOTFILES_DIR/sddm-theme/"* "$SDDM_THEME_DIR/"
ok "Theme installed"

# Copy fonts
info "Copying fonts..."
sudo cp -r "$SDDM_THEME_DIR/Fonts/"* /usr/share/fonts/
ok "Fonts copied"

# Configure /etc/sddm.conf
info "Configuring /etc/sddm.conf..."
printf '[Theme]\nCurrent=sddm-astronaut-theme\n' | sudo tee /etc/sddm.conf > /dev/null
ok "/etc/sddm.conf configured"

# Configure virtual keyboard
info "Configuring virtual keyboard..."
sudo mkdir -p /etc/sddm.conf.d
printf '[General]\nInputMethod=qtvirtualkeyboard\n' | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null
ok "Virtual keyboard configured"

# Set gruvbox_light theme
info "Setting theme to gruvbox_light..."
sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/gruvbox_light.conf|' \
    "$SDDM_THEME_DIR/metadata.desktop"
ok "Theme set to gruvbox_light"

# Enable SDDM
info "Enabling SDDM service..."
sudo systemctl enable sddm 2>/dev/null && ok "SDDM enabled" || warn "SDDM enable skipped"

# ══════════════════════════════════════════════════════════════════
sep
echo -e "\n${GRN}${BLD}  ✓  Installation complete!${NC}"
echo -e "${DIM}────────────────────────────────────────────────────────────${NC}"
echo -e "${WHT}  Don't forget:${NC}"
echo -e "${CYN}  →  ${WHT}Copy your wallpapers to ${YLW}~/Pictures/Wallpapers/${NC}"
echo -e "${CYN}  →  ${WHT}Open wallpaper selector with ${YLW}Super + I${NC}"
echo -e "${CYN}  →  ${WHT}Your last wallpaper is restored automatically on every boot${NC}"
echo -e "${CYN}  →  ${WHT}ZSH is now your default shell — ${YLW}re-login to activate${NC}"
echo -e "${DIM}────────────────────────────────────────────────────────────${NC}\n"

read -rp "$(echo -e "${YLW}  Reboot now? [Y/n]: ${NC}")" ans
[[ "${ans,,}" != "n" ]] && sudo reboot || echo -e "\n${GRN}  Done! Run 'Hyprland' to start.${NC}\n"
