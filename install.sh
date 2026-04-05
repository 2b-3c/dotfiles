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
BLU='\033[0;34m'
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
info() { echo -e "${BLU}  →  ${WHT}$*${NC}"; }
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

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZSH_CONFIG_DIR="$HOME/.config/zsh"

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

_aur_clone() {
    local repo_url="$1"
    local dest="$2"
    for attempt in 1 2 3; do
        info "Cloning $(basename "$dest") (attempt $attempt/3)..."
        rm -rf "$dest"
        if git clone "$repo_url" "$dest" 2>/dev/null; then
            return 0
        fi
        warn "Clone failed, retrying in 3 seconds..."
        sleep 3
    done
    return 1
}

if ! command -v yay &>/dev/null; then
    info "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel

    info "Checking network connectivity..."
    if ! curl -fsS --max-time 10 https://google.com > /dev/null 2>&1; then
        err "No internet connection detected."
        err "Please check your network and try again."
        exit 1
    fi
    ok "Network OK"

    YAY_INSTALLED=""

    info "Trying yay from AUR..."
    if curl -fsS --max-time 10 https://aur.archlinux.org > /dev/null 2>&1; then
        if _aur_clone "https://aur.archlinux.org/yay.git" /tmp/yay-build; then
            cd /tmp/yay-build && makepkg -si --noconfirm && cd "$DOTFILES_DIR"
            rm -rf /tmp/yay-build
            YAY_INSTALLED="yes"
            ok "yay installed"
        fi
    else
        warn "aur.archlinux.org unreachable, trying GitHub mirror..."
    fi

    if [[ -z "$YAY_INSTALLED" ]]; then
        info "Trying yay from GitHub mirror..."
        if _aur_clone "https://github.com/Jguer/yay.git" /tmp/yay-build; then
            cd /tmp/yay-build && makepkg -si --noconfirm && cd "$DOTFILES_DIR"
            rm -rf /tmp/yay-build
            YAY_INSTALLED="yes"
            ok "yay installed from GitHub mirror"
        fi
    fi

    if [[ -z "$YAY_INSTALLED" ]]; then
        err "Failed to install yay."
        exit 1
    fi
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
    hyprlock \
    hypridle \
    hyprsunset \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    xorg-xwayland

install_pkgs "Wayland utilities" \
    grim \
    slurp \
    grimblast-git \
    awww \
    wl-clipboard \
    imagemagick \
    iw

install_pkgs "Session & Auth" \
    hyprpolkitagent

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

install_pkgs "cliphist (Wayland clipboard manager)" \
    cliphist

# ══════════════════════════════════════════════════════════════════
# 5 — Waybar
# ══════════════════════════════════════════════════════════════════
step "5 — Waybar (status bar)"

install_pkgs "Waybar + Python deps" \
    waybar \
    python \
    python-requests \
    python-gobject \
    pacman-contrib \
    upower \
    jq \
    curl

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
    libpulse \
    wiremix

# ══════════════════════════════════════════════════════════════════
# 8 — Network & Bluetooth
# ══════════════════════════════════════════════════════════════════
step "8 — Network & Bluetooth"

install_pkgs "NetworkManager + Bluetooth" \
    networkmanager \
    network-manager-applet \
    bluez \
    bluez-utils \
    bluetui \
    impala \
    rfkill

# ══════════════════════════════════════════════════════════════════
# 9 — Screenshot & Screen Recording & Color Picker
# ══════════════════════════════════════════════════════════════════
step "9 — Screenshot, Screen Recording & Color Picker"

install_pkgs "Screenshot tools" \
    grim \
    slurp \
    hyprpicker \
    satty

install_pkgs "Screen recording (gpu-screen-recorder + webcam support)" \
    gpu-screen-recorder \
    v4l-utils \
    v4l2loopback-dkms \
    linux-headers

install_pkgs "Video processing" \
    ffmpeg \
    ffplay

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
    yaru-icon-theme \
    bibata-cursor-theme

install_pkgs "Shell utilities" \
    fzf \
    zoxide \
    starship \
    zsh \
    tmux \
    lsd \
    bat \
    neovim \
    yazi \
    fd \
    ffmpeg \
    ffmpegthumbnailer \
    perl-image-exiftool \
    ripgrep \
    p7zip \
    rsync

# ══════════════════════════════════════════════════════════════════
# 13 — ZSH Setup
# ══════════════════════════════════════════════════════════════════
step "13 — ZSH Setup"
CURRENT_SHELL=$(getent passwd "$USER" | cut -d: -f7)
ZSH_PATH=$(command -v zsh)

if [[ "$CURRENT_SHELL" != "$ZSH_PATH" ]]; then
    info "Setting zsh as default shell..."
    if ! grep -q "$ZSH_PATH" /etc/shells 2>/dev/null; then
        echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
    fi
    chsh -s "$ZSH_PATH"
    ok "Default shell set to zsh ($ZSH_PATH)"
else
    ok "ZSH is already the default shell"
fi

# Copy zsh plugins from dotfiles
info "Copying bundled zsh plugins..."
mkdir -p "$ZSH_CONFIG_DIR"

ZSH_SRC="$DOTFILES_DIR/.config/zsh"
if [ -d "$ZSH_SRC" ]; then
    cp -r "$ZSH_SRC"/. "$ZSH_CONFIG_DIR/"
    ok "ZSH plugins copied → $ZSH_CONFIG_DIR"
    ok "  • zsh-syntax-highlighting"
    ok "  • zsh-autosuggestions"
    ok "  • zsh-history-substring-search"
else
    warn "ZSH plugins directory not found in dotfiles — skipping"
fi

# Copy .zshrc
if [[ -f "$DOTFILES_DIR/.zshrc" ]]; then
    [ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak_$(date +%Y%m%d_%H%M%S)" && \
        info "Backed up existing .zshrc"
    cp "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    ok ".zshrc deployed"
fi

# ══════════════════════════════════════════════════════════════════
# 14 — Activate Bibata Cursor
# ══════════════════════════════════════════════════════════════════
step "14 — Activate Bibata Cursor"

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
# 15 — Enable System Services
# ══════════════════════════════════════════════════════════════════
step "15 — Enable System Services"

info "Creating systemd user directory..."
mkdir -p "$HOME/.config/systemd/user"

info "Setting up systemd user services..."

cat > "$HOME/.config/systemd/user/hyprsunset.service" << 'EOF'
[Unit]
Description=Hyprsunset blue light filter
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/hyprsunset -t 4500
Restart=on-failure

[Install]
WantedBy=graphical-session.target
EOF

cat > "$HOME/.config/systemd/user/swaync.service" << 'EOF'
[Unit]
Description=SwayNotificationCenter
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/swaync
Restart=on-failure

[Install]
WantedBy=graphical-session.target
EOF

systemctl --user daemon-reload
ok "User services configured"

info "Enabling NetworkManager..."
sudo systemctl enable --now NetworkManager 2>/dev/null && ok "NetworkManager" || warn "NetworkManager skipped"

info "Enabling Bluetooth..."
sudo systemctl enable --now bluetooth 2>/dev/null && ok "bluetooth" || warn "Bluetooth skipped"

info "Enabling UPower..."
sudo systemctl enable --now upower 2>/dev/null && ok "UPower" || warn "UPower skipped"

info "Enabling PipeWire (user services)..."
systemctl --user enable --now pipewire       2>/dev/null && ok "pipewire"       || warn "pipewire skipped"
systemctl --user enable --now pipewire-pulse 2>/dev/null && ok "pipewire-pulse" || warn "pipewire-pulse skipped"
systemctl --user enable --now wireplumber    2>/dev/null && ok "wireplumber"    || warn "wireplumber skipped"

# ══════════════════════════════════════════════════════════════════
# 16 — Create Required Directories
# ══════════════════════════════════════════════════════════════════
step "16 — Create Required Directories"

DIRS=(
    "$HOME/Pictures/Screenshots"
    "$HOME/Videos"
    "$HOME/Pictures/Wallpapers"
    "$HOME/Wallpapers/Pictures"
    "$HOME/Wallpapers/Users"
    "$HOME/.local/share/fonts"
    "$HOME/.local/share/applications"
    "$HOME/.local/bin"
    "$HOME/.cache"
    "$HOME/.trash"
)

for dir in "${DIRS[@]}"; do
    mkdir -p "$dir"
    ok "Created: $dir"
done

# ══════════════════════════════════════════════════════════════════
# 16.1 — Setup fastfetch state files
# ══════════════════════════════════════════════════════════════════
step "16.1 — Setup fastfetch state files"

OMARCHY_DIR="$HOME/.config/omarchy"
CURRENT_DIR="$HOME/.config/omarchy/current"

mkdir -p "$OMARCHY_DIR" "$CURRENT_DIR"

# Version file used by fastfetch/scripts/version.sh
echo "1.0.0" > "$OMARCHY_DIR/version"
ok "Version file → $OMARCHY_DIR/version"

# Theme name file used by fastfetch/scripts/theme-current.sh
echo "gruvbox-light" > "$CURRENT_DIR/theme.name"
ok "Theme state → $CURRENT_DIR/theme.name"

# ══════════════════════════════════════════════════════════════════
# 17 — Deploy Dotfiles
# ══════════════════════════════════════════════════════════════════
step "17 — Deploy Dotfiles"

CONFIG_SRC="$DOTFILES_DIR/.config"
CONFIG_DST="$HOME/.config"

if [[ ! -d "$CONFIG_SRC" ]]; then
    err ".config directory not found — run this script from the dotfiles folder"
    exit 1
fi

# Backup existing configs
BACKUP="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP"

COMPONENTS=(hypr waybar kitty rofi swaync btop cava fastfetch zsh tmux)
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

# Deploy .gitconfig
if [[ -f "$DOTFILES_DIR/.gitconfig" ]]; then
    if [[ -f "$HOME/.gitconfig" ]]; then
        cp "$HOME/.gitconfig" "$BACKUP/.gitconfig.bak" 2>/dev/null || true
    fi
    cp "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
    ok ".gitconfig deployed → ~/.gitconfig"
fi

# Make all hypr scripts executable
find "$CONFIG_DST/hypr/scripts" -type f -name "*.sh" -exec chmod +x {} +
find "$CONFIG_DST/waybar/scripts" -type f -exec chmod +x {} +
find "$CONFIG_DST/rofi/scripts" -type f -name "*.sh" -exec chmod +x {} +
find "$CONFIG_DST/swaync/scripts" -type f -name "*.sh" -exec chmod +x {} +
ok "Script permissions set"

# Create Videos directory for screen recordings
mkdir -p "$HOME/Videos"
ok "Videos directory created → ~/Videos"

# Copy theme wallpapers
mkdir -p "$HOME/Pictures/Wallpapers"
cp -r "$DOTFILES_DIR/wallpapers/themes" "$HOME/Pictures/Wallpapers/" 2>/dev/null || true
ok "Theme wallpapers copied → ~/Pictures/Wallpapers/themes"

# ══════════════════════════════════════════════════════════════════
# 17.1 — Apply Gruvbox Light Theme
# ══════════════════════════════════════════════════════════════════
step "17.1 — Apply Gruvbox Light Theme"

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

# Yaru icon theme — set Bark (warm) for default Gruvbox Light theme
# Symlink Adwaita navigation icons required by Nautilus (same as omarchy)
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-previous-symbolic.svg \
    /usr/share/icons/Yaru/scalable/actions/go-previous-symbolic.svg 2>/dev/null || true
sudo ln -snf /usr/share/icons/Adwaita/symbolic/actions/go-next-symbolic.svg \
    /usr/share/icons/Yaru/scalable/actions/go-next-symbolic.svg 2>/dev/null || true
sudo gtk-update-icon-cache /usr/share/icons/Yaru 2>/dev/null || true
sudo gtk-update-icon-cache /usr/share/icons/Yaru-bark 2>/dev/null || true
ok "Yaru icon theme configured (default: Yaru-bark for Gruvbox Light)"

# Wallpaper — save path to restore on first launch
GRUVBOX_WALL="$HOME/Pictures/Wallpapers/themes/gruvbox-light.png"
echo "$GRUVBOX_WALL" > "$CONFIG_DST/hypr/.current_wallpaper"
ok "Default wallpaper → Gruvbox Light"

# ══════════════════════════════════════════════════════════════════
# 18 — Set Script Permissions
# ══════════════════════════════════════════════════════════════════
step "18 — Set Script Permissions"

SCRIPT_DIRS=(
    "$CONFIG_DST/waybar/scripts"
    "$CONFIG_DST/rofi/scripts"
    "$CONFIG_DST/swaync/scripts"
    "$CONFIG_DST/hypr/scripts"
    "$CONFIG_DST/fastfetch/scripts"
    "$CONFIG_DST/yazi"
)

for dir in "${SCRIPT_DIRS[@]}"; do
    if [[ -d "$dir" ]]; then
        find "$dir" -type f -name "*.sh" -exec chmod +x {} +
        find "$dir" -type f -name "*.py" -exec chmod +x {} +
        find "$dir" -type f ! -name "*.*" -exec chmod +x {} + 2>/dev/null || true
        ok "chmod +x → $dir"
    fi
done

# ── GTK Settings ──
info "Applying GTK settings..."
# GTK theme files are already in place from the dotfiles deploy in step 17.
# Just apply the default Gruvbox Light theme files directly.
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cp "$CONFIG_DST/gtk-3.0/themes/gruvbox-light.css" "$HOME/.config/gtk-3.0/gtk.css"
cp "$CONFIG_DST/gtk-4.0/themes/gruvbox-light.css" "$HOME/.config/gtk-4.0/gtk.css"
cp "$CONFIG_DST/gtk-3.0/themes/gruvbox-light.ini" "$HOME/.config/gtk-3.0/settings.ini"
cp "$CONFIG_DST/gtk-4.0/themes/gruvbox-light.ini" "$HOME/.config/gtk-4.0/settings.ini"
gsettings set org.gnome.desktop.interface gtk-theme    "Adwaita"                2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme   "Yaru-bark"              2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme "Bibata-Modern-Classic"  2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-size  16                       2>/dev/null || true
gsettings set org.gnome.desktop.interface color-scheme "prefer-light"           2>/dev/null || true
gsettings set org.gnome.desktop.interface font-name    "Noto Sans 11"           2>/dev/null || true
ok "GTK settings applied"

# ── Font cache ──
info "Updating font cache..."
fc-cache -f &>/dev/null
ok "Font cache updated"

# ══════════════════════════════════════════════════════════════════
# 19 — SDDM & sddm-astronaut-theme
# ══════════════════════════════════════════════════════════════════
step "19 — SDDM Display Manager & Theme"

install_pkgs "SDDM + Qt6 dependencies" \
    sddm \
    qt6-svg \
    qt6-virtualkeyboard \
    qt6-multimedia-ffmpeg

# Copy theme from dotfiles
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

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
echo -e "\n${GRN}${BLD}  ✓  Installation complete!${NC}\n"
sep

echo -e "${WHT}  Things you may need to configure manually:${NC}"
echo -e "${DIM}  ┌─────────────────────────────────────────────────────────┐${NC}"
echo -e "${DIM}  │${NC}  ${YLW}~/.config/waybar/scripts/weather.sh${NC}   → Set LAT & LON"
echo -e "${DIM}  │${NC}  ${YLW}~/.config/hypr/custom/monitors.conf${NC}   → Set your monitor"
echo -e "${DIM}  │${NC}  ${YLW}~/.config/hypr/custom/devices.conf${NC}    → Set your devices"
echo -e "${DIM}  │${NC}  ${YLW}~/Pictures/Wallpapers/${NC}                → Add more wallpapers"
echo -e "${DIM}  │${NC}  ${YLW}~/.zshrc${NC}                              → Customize your shell"
echo -e "${DIM}  └─────────────────────────────────────────────────────────┘${NC}"

echo -e "\n${WHT}  ZSH plugins installed in ~/.config/zsh/:${NC}"
echo -e "${DIM}  ┌─────────────────────────────────────────────────────────┐${NC}"
echo -e "${DIM}  │${NC}  ${CYN}zsh-syntax-highlighting${NC}      → command syntax highlighting"
echo -e "${DIM}  │${NC}  ${CYN}zsh-autosuggestions${NC}          → auto-suggestions"
echo -e "${DIM}  │${NC}  ${CYN}zsh-history-substring-search${NC} → history substring search"
echo -e "${DIM}  └─────────────────────────────────────────────────────────┘${NC}"

echo -e "\n${CYN}  →  ${WHT}Open wallpaper selector with ${YLW}Super + I${NC}"
echo -e "${CYN}  →  ${WHT}Your last wallpaper is restored automatically on every boot${NC}"
echo -e "${CYN}  →  ${WHT}ZSH is now your default shell — ${YLW}re-login to activate${NC}\n"

sep
read -rp "$(echo -e "${YLW}  Reboot now? [Y/n]: ${NC}")" ans
[[ "${ans,,}" != "n" ]] && sudo reboot || echo -e "\n${GRN}  Done! Run 'Hyprland' to start.${NC}\n"
