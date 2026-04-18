# Hyprland Dotfiles

![Screenshot](screenshots/1.png)
![Screenshot](screenshots/2.png)
![Screenshot](screenshots/3.png)
![Screenshot](screenshots/4.png)

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
| Shell | Zsh |
| Shell Prompt | Starship |
| File Manager | Nautilus |
| Clipboard | cliphist |
| System Monitor | btop |
| Visualizer | cava |
| File Previewer | ctpv |
| ls replacement | lsd |
| Night Light | hyprsunset |
| Multiplexer | tmux |
| Screenshot Editor | Satty |
| Screen Recorder | gpu-screen-recorder |
| Login Screen | SDDM |

---

## ✨ Features

### 🎨 Theme System
Change the theme from **Menu → Style → Themes** — applies instantly to:
- Waybar · SwayNC · Kitty · Rofi · btop · cava · Starship · Window borders · Wallpaper · Icons

**Available themes:**
`Gruvbox` · `Gruvbox Light` · `Miasma` · `Osaka Jade` · `Retro 82` · `Ristretto` · `Tokyo Night` · `Vantablack` · `White`

---

### 🖥️ SDDM Login Screen
Change the login screen theme from **Menu → Style → SDDM Theme**:

**Available themes:** `Gruvbox Dark` · `Gruvbox Light`

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
- Time and date centered with Electroharmonix font
- Password input field with sharp corners

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

### 󰤨 Wi-Fi & Bluetooth Menus
- **Wi-Fi menu** — connect to networks directly from Rofi
- **Bluetooth menu** — manage paired devices from Rofi
- Access via `Super + Space` → dedicated menus or Waybar click

---

### 󰝚 Now Playing (`Super + O`)
Media player controls in a floating Rofi overlay — shows current track, play/pause, next/previous.

---

### 🌙 Night Light (hyprsunset)
Toggle warm color temperature from SwayNC or with `Super + Shift + N`. Uses `hyprsunset` directly — no systemd service needed.

---

### 󰌆 File Manager (`Super + E`)
Opens Nautilus file manager.

---

### 🪟 Window Groups (Tabbed Windows)
- `Super + G` — Toggle window group
- `Super + Alt + G` — Move window out of group
- `Super + Alt + Tab` / `Super + Ctrl + Left/Right` — Cycle group tabs

---

### 📌 Scratchpad
- `Super + S` — Toggle scratchpad
- `Super + Alt + S` — Move window to scratchpad

---

## ⚙️ Installation

```bash
git clone https://github.com/2b-3c/dotfiles
cd dotfiles
bash install.sh
```

> The installer handles everything: packages, configs, permissions, services, and applies Gruvbox as the default theme.

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
```

---

## 📦 Dependencies

### Core
```
hyprland hyprlock hypridle hyprpicker hyprsunset
xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
xorg-xwayland wayland-protocols qt5-wayland qt6-wayland
grim slurp awww swaync
wl-clipboard cliphist imagemagick
hyprpolkitagent sddm dbus
```

### Audio
```
pipewire pipewire-pulse pipewire-alsa wireplumber
wpctl pamixer pavucontrol playerctl python-gobject
```

### Network
```
networkmanager nm-connection-editor bluez bluez-utils rfkill
```

### UI
```
waybar rofi-wayland rofi-emoji
brightnessctl upower jq curl fzf libnotify iw
```

### Applications
```
kitty neovim starship firefox zsh
btop cava mpv tmux
nautilus lsd ctpv fd ripgrep p7zip ffmpeg rsync
satty gpu-screen-recorder hyprpicker
ffmpegthumbnailer perl-image-exiftool
```

### Fonts & Icons
```
ttf-jetbrains-mono-nerd
noto-fonts noto-fonts-emoji otf-font-awesome
papirus-icon-theme bibata-cursor-theme
```

> The `Electroharmonix` font used in the lock screen is bundled in `sddm-theme/Fonts/` — copy it to `~/.local/share/fonts/` and run `fc-cache -f`.

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
| `Super + E` | File manager (Nautilus) |
| `Super + F` | Browser (Firefox) |
| `Super + N` | Toggle notifications |

### Screenshots

| Shortcut | Action |
|----------|--------|
| `Print` | Smart screenshot (click window or draw region) |
| `Super + Print` | Full screen screenshot |
| `Ctrl + Super + Print` | Window snap screenshot |
| `Super + Shift + S` | Region screenshot to clipboard only |

> Screenshots are saved to `~/Pictures/Screenshots/` and copied to clipboard. A notification with an **Edit** button opens Satty for annotation.

### Screen Recording

| Shortcut | Action |
|----------|--------|
| `Super + Shift + R` | Start / stop screen recording |
| `Super + Shift + Alt + R` | Start recording with desktop + mic audio |

> Recordings are saved to `~/Videos/`. A Waybar indicator (` REC`) appears while recording. Click it to stop.

### Audio

| Shortcut | Action |
|----------|--------|
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |
| `XF86AudioMute` | Mute |
| `XF86AudioMicMute` | Mute microphone |
| `XF86AudioPlay/Pause` | Play/Pause |
| `XF86AudioNext/Prev` | Next/Previous track |
| `Super + XF86AudioMute` | Switch audio output device |

### Brightness

| Shortcut | Action |
|----------|--------|
| `XF86MonBrightnessUp/Down` | Brightness up/down |

### Display & Layout

| Shortcut | Action |
|----------|--------|
| `Super + F8` | Cycle monitor scaling |
| `Super + Shift + F8` | Toggle single-window square aspect ratio |
| `Super + Shift + N` | Toggle night light (hyprsunset) |
| `Super + L` | Toggle workspace layout (dwindle ↔ master) |
| `Super + Backspace` | Toggle window transparency |
| `Super + Shift + Backspace` | Toggle window gaps |

> Fonts can be changed system-wide with `font-set.sh <font-name>`. Use `font-list.sh` to list available monospace fonts, `font-current.sh` to see the active one.

### Window Management

| Shortcut | Action |
|----------|--------|
| `Super + Q` | Close window |
| `Super + V` | Toggle floating |
| `Super + P` | Toggle pseudo-tiling |
| `Super + J` | Toggle split |
| `Super + F11` | Full screen |
| `Super + U` | Pop window out (float + pin) |
| `Super + Arrows` | Move focus |
| `Super + Shift + Arrows` | Swap window |
| `Super + [-] / [=]` | Resize window horizontally |
| `Super + Shift + [-] / [=]` | Resize window vertically |
| `Super + Mouse drag` | Move window |
| `Super + Right Click` | Resize window |

### Window Groups (Tabbed)

| Shortcut | Action |
|----------|--------|
| `Super + G` | Toggle window group |
| `Super + Alt + G` | Move window out of group |
| `Super + Alt + Tab` | Next window in group |
| `Super + Alt + Shift + Tab` | Previous window in group |
| `Super + Ctrl + Left/Right` | Cycle group tabs |
| `Super + Alt + Arrows` | Move window into adjacent group |

### Workspaces

| Shortcut | Action |
|----------|--------|
| `Super + 1-0` | Switch to workspace 1-10 |
| `Super + Shift + 1-0` | Move window to workspace |
| `Super + Shift + Alt + 1-0` | Move window silently to workspace |
| `Super + TAB` | Next workspace |
| `Super + Shift + TAB` | Previous workspace |
| `Super + Ctrl + TAB` | Former workspace |
| `Super + Scroll` | Switch workspaces |
| `Super + Shift + Alt + Arrows` | Move workspace to another monitor |
| `Super + S` | Toggle scratchpad |
| `Super + Alt + S` | Move window to scratchpad |

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
│   ├── hypridle.conf
│   ├── autostart.conf
│   ├── bindings.conf
│   ├── colors.conf
│   ├── env.conf
│   ├── input.conf
│   ├── looknfeel.conf
│   ├── monitors.conf
│   ├── windowrules.conf
│   ├── xdph.conf
│   └── scripts/
│       ├── restore_wallpaper.sh
│       ├── screenshot.sh
│       ├── screenrecord.sh
│       ├── font-set.sh
│       ├── font-list.sh
│       ├── font-current.sh
│       ├── monitor-scaling-cycle.sh
│       ├── audio-switch.sh
│       ├── nightlight-toggle.sh
│       ├── idle-toggle.sh
│       ├── waybar-toggle.sh
│       ├── workspace-layout-toggle.sh
│       ├── one-window-ratio-toggle.sh
│       ├── window-single-square-toggle.sh
│       ├── window-pop.sh
│       ├── window-gaps-toggle.sh
│       └── window-transparency-toggle.sh
│
├── waybar/
│   ├── config.jsonc
│   ├── style.css
│   ├── theme.css
│   ├── themes/
│   └── scripts/
│       ├── bluetooth-menu.sh
│       ├── brightness-control.sh
│       ├── cpu-temp.sh
│       ├── cpu-usage.sh
│       ├── logout-menu.sh
│       ├── mediaplayer.py
│       ├── system-update.sh
│       ├── volume-control.sh
│       ├── wifi-menu.sh
│       └── wifi-status.sh
│
├── rofi/
│   ├── app-launcher.rasi
│   ├── bluetooth.rasi
│   ├── clipboard.rasi
│   ├── config.rasi
│   ├── emoji.rasi
│   ├── image-clipboard.rasi
│   ├── launcher-menu.rasi
│   ├── logout-menu.rasi
│   ├── nowplaying/
│   ├── run-launcher.rasi
│   ├── wallpaper-select.rasi
│   ├── wifi.rasi
│   ├── wifi-bluetooth-menu.rasi
│   ├── window-switcher.rasi
│   ├── themes/
│   └── scripts/
│       ├── aur-installer.sh
│       ├── clipboard-images.sh
│       ├── launcher-menu.sh
│       ├── nowplaying.sh
│       ├── pacman-installer.sh
│       ├── pkg-remove-tui.sh
│       ├── pkg-update-tui.sh
│       ├── sddm-theme.sh
│       ├── theme-select.sh
│       ├── wallpaper-select.sh
│       └── window-switcher.sh
│
├── swaync/
│   ├── config.json
│   ├── style.css
│   ├── theme.css
│   ├── themes/
│   └── scripts/
│       ├── battery_label.sh
│       ├── detect_backlight.sh
│       ├── get_battery_mode.sh
│       ├── toggle_airplanemode.sh
│       ├── toggle_battery_mode.sh
│       ├── toggle_bluetooth.sh
│       ├── toggle_hypridle.sh
│       ├── toggle_hyprsunset.sh
│       ├── toggle_wifi.sh
│       └── update_hypridle.sh
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
│   ├── waybar-left
│   ├── waybar-right
│   └── themes/
│
├── starship/
│   └── themes/
│       └── gruvbox-light.toml
│
├── fastfetch/
│   ├── config.jsonc
│   ├── onyx.txt
│   └── scripts/
│
├── ctpv/
│   └── config
│
├── lsd/
│   └── config.yaml
│
├── tmux/
│   └── tmux.conf
│
├── icons-themes/
│   ├── gruvbox
│   ├── gruvbox-light
│   ├── miasma
│   ├── osaka-jade
│   ├── retro-82
│   ├── ristretto
│   ├── tokyo-night
│   ├── vantablack
│   └── white
│
├── gtk-3.0/
│   ├── gtk.css
│   ├── settings.ini
│   └── themes/
│
└── gtk-4.0/
    ├── gtk.css
    ├── settings.ini
    └── themes/

~/
├── .zshrc
├── .gitconfig
├── Videos/                  ← screen recordings
├── Pictures/
│   ├── Screenshots/
│   └── Wallpapers/
│       └── themes/
│           ├── gruvbox.jpg
│           ├── gruvbox-light.png
│           ├── miasma.jpg
│           ├── osaka-jade.jpg
│           ├── retro-82.jpg
│           ├── ristretto.jpg
│           ├── tokyo-night.png
│           ├── vantablack.jpg
│           └── white.jpg
│
└── dotfiles/
    └── sddm-theme/
        ├── Main.qml
        ├── Components/
        ├── Assets/
        ├── Fonts/
        │   └── Electroharmonix.otf
        ├── Themes/
        │   ├── gruvbox_dark.conf
        │   └── gruvbox_light.conf
        └── Backgrounds/
            ├── gruvbox_dark.png
            └── gruvbox_light.png
```

---

## ⚠️ Manual Configuration After Install

| File | What to Edit |
|------|-------------|
| `~/.config/hypr/monitors.conf` | Monitor name, resolution, and refresh rate |
| `~/.config/hypr/input.conf` | Keyboard layout and mouse settings |
| `~/.config/hypr/hyprland.conf` | Default terminal, browser, or file manager |

---

## 📝 Notes

- Default theme: **Gruvbox Light** — applied automatically on install
- Screenshots are saved to `~/Pictures/Screenshots/`
- A config backup is saved to `~/.config_backup_*` on every install
- Wallpaper is restored automatically on every boot via `restore_wallpaper.sh`
- Hyprland config is split into sub-files — edit each section in its own file
- Night light (hyprsunset) toggled via `Super + Shift + N` or SwayNC
- The `Electroharmonix` font (used in lock screen) is bundled — install it from `sddm-theme/Fonts/`
- Zsh plugins (autosuggestions, syntax-highlighting, history-substring-search) are bundled in `~/.config/zsh/`

---

## 🤝 Contributing

Suggestions and fixes are welcome — open an Issue or PR.
