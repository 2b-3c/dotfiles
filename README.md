# Hyprland Dotfiles

![Screenshot](screenshots/1.png)

A personal Hyprland setup — clean, fast, and themeable.

---

## 🖥️ Components

| Component | Tool |
|-----------|------|
| Compositor | Hyprland |
| Bar | Waybar |
| Launcher | Rofi (wayland) |
| Terminal | Kitty |
| Notifications | SwayNC |
| Wallpaper | awww |
| Lock Screen | Hyprlock + Hypridle |
| Shell Prompt | Starship |
| File Manager | lf |
| Clipboard | cliphist |
| System Monitor | btop |
| Fetch | fastfetch |
| Visualizer | cava |

---

## ✨ Features

### 🎨 Theme System
Change the theme from **Menu → Style → Themes** — applies instantly to:
- Waybar · SwayNC · Kitty · Rofi · btop · cava · Starship · Window borders · Wallpaper

**Available themes:** `Black Hole` · `Cyberpunk` · `Gruvbox Light`

---

### 🖥️ SDDM Login Screen
Change the login screen theme from **Menu → Style → SDDM Theme**:

**Available themes:** `Black Hole` · `Cyberpunk` · `Gruvbox Light`

---

### 󰸉 Wallpaper Menu (`Super + I`)

Change desktop wallpaper from `~/Pictures/Wallpapers/` with thumbnail previews.

---

### 󰅍 Clipboard
- `Super + C` — Text clipboard
- `Super + Shift + C` — Image clipboard with thumbnails

---

### 󰷛 Lock Screen (`Super + Shift + X`)
- Blurred screenshot as background
- Time and date centered
- Password input field

---

### 󰀻 Rofi Main Menu (`Super + Space`)

| Option | Function |
|--------|----------|
| Apps | Full app launcher |
| Install | Install packages (Pacman / AUR) |
| Remove | Remove packages |
| Update | Update system |
| Wallpaper | Change wallpaper |
| Style | Themes · SDDM Theme |
| About | System info |
| System | Lock · Logout · Suspend · Reboot · Shutdown |

---

### 󰌆 lf File Manager (`Super + E`)
Opens as a floating window with image/video preview via ctpv.

---

## ⚙️ Installation

```bash
git clone https://github.com/2b-3c/dotfiles
cd dotfiles
bash install.sh
```

> The installer handles everything: packages, configs, permissions, services, and applies Gruvbox Light as the default theme.

### Manual

```bash
git clone https://github.com/2b-3c/dotfiles
cd dotfiles

cp -r .config/* ~/.config/
mkdir -p ~/Pictures/Screenshots ~/Pictures/Wallpapers

find ~/.config/rofi/scripts   -type f -name "*.sh" -exec chmod +x {} +
find ~/.config/waybar/scripts -type f               -exec chmod +x {} +
find ~/.config/swaync/scripts -type f -name "*.sh" -exec chmod +x {} +
find ~/.config/hypr/scripts   -type f -name "*.sh" -exec chmod +x {} +
find ~/.config/lf/previewer   -type f               -exec chmod +x {} +
```

---

## 📦 Dependencies

### Core
```
hyprland hyprlock hypridle hyprpicker
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
xorg-xwayland wayland-protocols qt5-wayland qt6-wayland
grim slurp awww swaync
wl-clipboard cliphist imagemagick
polkit-gnome sddm dbus
```

### Audio
```
pipewire pipewire-pulse pipewire-alsa wireplumber
pamixer pavucontrol playerctl python-gobject
```

### Network
```
networkmanager nm-connection-editor bluez bluez-utils rfkill
```

### UI
```
waybar rofi-wayland rofi-emoji
brightnessctl upower jq curl fzf libnotify
```

### Applications
```
kitty neovim starship firefox
btop fastfetch cava mpv
lf ctpv fd ripgrep p7zip ffmpeg rsync
hypridle ffmpegthumbnailer perl-image-exiftool
```

### Fonts & Icons
```
ttf-jetbrains-mono-nerd
noto-fonts noto-fonts-emoji otf-font-awesome
papirus-icon-theme bibata-cursor-theme
```

---

## ⌨️ Keybindings

> `$mod` = Super

### Menus

| Shortcut | Action |
|----------|--------|
| `Super + Space` | Main menu |
| `Super + A` | App launcher |
| `Super + R` | Run launcher |
| `Super + C` | Text clipboard |
| `Super + Shift + C` | Image clipboard |
| `Super + .` | Emoji picker |
| `Super + W` | Window switcher |
| `Super + O` | Now Playing |
| `Super + I` | Wallpaper selector |

### Applications

| Shortcut | Action |
|----------|--------|
| `Super + T` | Terminal (Kitty) |
| `Super + E` | File manager (lf) |
| `Super + F` | Browser (Firefox) |
| `Super + N` | Toggle notifications |

### Screenshots

| Shortcut | Action |
|----------|--------|
| `Print` | Copy screen to clipboard |
| `Super + Print` | Save full screen to file |
| `Ctrl + Super + Print` | Save active window to file |
| `Ctrl + Print` | Copy active window to clipboard |
| `Ctrl + Shift + Print` | Save selected region to file |
| `Super + Shift + S` | Copy selected region to clipboard |

### Audio

| Shortcut | Action |
|----------|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute |
| `XF86AudioMicMute` | Mute microphone |
| `XF86AudioPlay/Pause` | Play/Pause |
| `XF86AudioNext/Prev` | Next/Previous track |

### Brightness

| Shortcut | Action |
|----------|--------|
| `XF86MonBrightnessUp/Down` | Brightness up/down |

### Window Management

| Shortcut | Action |
|----------|--------|
| `Super + Q` | Close window |
| `Super + V` | Toggle floating |
| `Super + P` | Toggle pseudo-tiling |
| `Super + J` | Toggle split |
| `Super + Arrows` | Move focus |
| `Super + Shift + Arrows` | Move window |
| `Super + Mouse drag` | Move window |
| `Super + Right Click` | Resize window |
| `Ctrl + Super + Arrows` | Resize window |

### Workspaces

| Shortcut | Action |
|----------|--------|
| `Super + 1-0` | Switch to workspace 1-10 |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + Scroll` | Switch workspaces |

### System

| Shortcut | Action |
|----------|--------|
| `Super + Shift + X` | Lock screen |
| `Super + Shift + B` | Restart Waybar |
| `Super + Shift + M` | Exit Hyprland |

---

## 📁 File Structure

```
~/.config/
├── hypr/
│   ├── hyprland.conf
│   ├── hyprlock.conf
│   ├── hyprpaper.conf
│   ├── hypridle.conf
│   └── scripts/
│       └── restore_wallpaper.sh
│
├── waybar/
│   ├── config.jsonc
│   ├── style.css
│   ├── theme.css
│   ├── themes/
│   │   ├── black-hole.css
│   │   ├── cyberpunk.css
│   │   └── gruvbox-light.css
│   └── scripts/
│
├── rofi/
│   ├── themes/
│   │   ├── theme.rasi
│   │   ├── black-hole.rasi
│   │   ├── cyberpunk.rasi
│   │   └── gruvbox-light.rasi
│   └── scripts/
│       ├── launcher-menu.sh
│       ├── theme-select.sh
│       ├── sddm-theme.sh
│       ├── wallpaper-select.sh
│       ├── clipboard-images.sh
│       └── nowplaying.sh
│
├── swaync/
│   ├── config.json
│   ├── style.css
│   ├── theme.css
│   ├── themes/
│   └── scripts/
│
├── kitty/
│   ├── kitty.conf
│   ├── theme.conf
│   └── themes/
│
├── btop/
│   ├── btop.conf
│   └── themes/
│
├── cava/
│   ├── config
│   └── themes/
│
├── fastfetch/
│   ├── config.jsonc
│   └── onyx.txt
│
├── lf/
│   ├── lfrc
│   ├── icons
│   ├── configs/
│   └── previewer/
│
├── ctpv/
│   └── config
│
├── lsd/
│   └── config.yaml
│
└── starship.toml

~/
├── Pictures/
│   ├── Screenshots/
│   └── Wallpapers/
│       └── themes/
│           ├── black-hole.png
│           ├── cyberpunk.png
│           └── gruvbox-light.png
│
└── dotfiles/
    └── sddm-theme/
        ├── Themes/
        └── Backgrounds/
```

---

## ⚠️ Manual Configuration After Install

| File | What to Edit |
|------|-------------|
| `~/.config/hypr/hyprland.conf` | Monitor name, resolution, and input devices |

---

## 📝 Notes

- Default theme: **Gruvbox Light** — applied automatically on install
- Screenshots are saved to `~/Pictures/Screenshots/`
- A config backup is saved to `~/.config_backup_*` on every install
- Wallpaper is restored automatically on every boot

---

## 🤝 Contributing

Suggestions and fixes are welcome — open an Issue or PR.
