#!/usr/bin/env bash

ROFI_CONF="$HOME/.config/rofi"
SCRIPTS="$ROFI_CONF/scripts"
HYPR_CONF="$HOME/.config/hypr"
DOTFILES="$HOME/dotfiles"

rofi_menu() {
    local input
    input=$(cat)
    local count
    count=$(echo "$input" | grep -c .)
    echo "$input" | rofi -dmenu -no-custom \
        -config "$ROFI_CONF/launcher-menu.rasi" \
        -lines "$count" \
        -theme-str "listview { lines: ${count}; } window { width: 260px; }"
}

open_url() { xdg-open "$1" & }
open_editor_kitty() { kitty --class "popup" --title "popup:$1" "${EDITOR:-nvim}" "$2"; }

# ── Main menu ─────────────────────────────────────────────
show_main() {
    printf '%s\n' \
        "󰀻   Apps" \
        "󰧑   Learn" \
        "󱓞   Trigger" \
        "   Style" \
        "   Setup" \
        "󰉉   Install" \
        "󰭌   Remove" \
        "   Update" \
        "   About" \
        "   System" \
    | rofi_menu
}

# ── Apps ─────────────────────────────────────────────────────────
menu_apps() {
    pkill rofi
    rofi -show drun -config "$ROFI_CONF/app-launcher.rasi"
}

# ── Learn ────────────────────────────────────────────────────────
menu_learn() {
    CHOICE=$(printf '%s\n' \
        "   Keybindings" \
        "󰋒   dotfiles" \
        "   Hyprland" \
        "󰣇   Arch" \
        "   Neovim" \
        "󱆃   Bash" \
    | rofi_menu)
    case "$CHOICE" in
        *Keybindings) menu_learn_keybindings ;;
        *dotfiles)    open_url "https://github.com/2b-3c/dotfiles" ;;
        *Hyprland)    open_url "https://wiki.hypr.land" ;;
        *Arch)        open_url "https://wiki.archlinux.org" ;;
        *Neovim)      open_url "https://lazyvim.org/keymaps" ;;
        *Bash)        open_url "https://devhints.io/bash" ;;
    esac
}

menu_learn_keybindings() {
    BINDINGS="$HYPR_CONF/bindings.conf"
    if [ -f "$BINDINGS" ]; then
        local items
        items=$(grep -E "^bind" "$BINDINGS" \
            | sed 's/bind[[:alpha:]]* = //' \
            | awk -F',' '{
                mod=$1; gsub(/^[ \t]+|[ \t]+$/, "", mod)
                key=$2; gsub(/^[ \t]+|[ \t]+$/, "", key)
                desc=$3; gsub(/^[ \t]+|[ \t]+$/, "", desc)
                printf "%-20s %-10s  %s\n", mod, key, desc
            }')
        local count
        count=$(echo "$items" | grep -c .)
        local visible
        visible=$(( count > 15 ? 15 : count ))
        echo "$items" | rofi -dmenu -no-custom \
            -config "$ROFI_CONF/launcher-menu.rasi" \
            -p "Keybindings" \
            -lines "$visible" \
            -theme-str "listview { lines: ${visible}; scrollbar: true; } window { width: 500px; }"
    else
        echo "   No bindings.conf found" | rofi -dmenu -no-custom \
            -config "$ROFI_CONF/launcher-menu.rasi" \
            -lines 1 \
            -theme-str "listview { lines: 1; } window { width: 320px; }"
    fi
}

# ── Trigger ──────────────────────────────────────────────────────
menu_trigger() {
    CHOICE=$(printf '%s\n' \
        "   Capture" \
        "󰔎   Toggle" \
    | rofi_menu)
    case "$CHOICE" in
        *Capture) menu_capture ;;
        *Toggle)  menu_toggle ;;
    esac
}

menu_capture() {
    CHOICE=$(printf '%s\n' \
        "  Screenshot" \
        "   Screenrecord" \
        "󰃉   Color" \
    | rofi_menu)
    case "$CHOICE" in
        *Screenshot)   menu_screenshot ;;
        *Screenrecord) menu_screenrecord ;;
        *Color)        hyprpicker -a ;;
    esac
}

menu_screenshot() {
    CHOICE=$(printf '%s\n' \
        "   Fullscreen" \
        "   Selection" \
        "   Window" \
        "   Smart" \
    | rofi_menu)
    case "$CHOICE" in
        *Fullscreen) bash "$HYPR_CONF/scripts/screenshot.sh" fullscreen ;;
        *Selection)  bash "$HYPR_CONF/scripts/screenshot.sh" region ;;
        *Window)     bash "$HYPR_CONF/scripts/screenshot.sh" windows ;;
        *Smart)      bash "$HYPR_CONF/scripts/screenshot.sh" smart ;;
    esac
}

menu_screenrecord() {
    # If already recording, stop
    if pgrep -f "gpu-screen-recorder" > /dev/null; then
        bash "$HYPR_CONF/scripts/screenrecord.sh" --stop-recording
        return
    fi

    CHOICE=$(printf '%s\n' \
        "  No audio" \
        "   Desktop audio" \
        "   Desktop + mic" \
        "   Desktop + mic + webcam" \
    | rofi_menu)
    [ -z "$CHOICE" ] && return

    case "$CHOICE" in
        *"No audio")    bash "$HYPR_CONF/scripts/screenrecord.sh" ;;
        *"Desktop audio")      bash "$HYPR_CONF/scripts/screenrecord.sh" --with-desktop-audio ;;
        *"Desktop + mic")      bash "$HYPR_CONF/scripts/screenrecord.sh" --with-desktop-audio --with-microphone-audio ;;
        *"webcam")             bash "$HYPR_CONF/scripts/screenrecord.sh" --with-desktop-audio --with-microphone-audio --with-webcam ;;
    esac
}

menu_toggle() {
    CHOICE=$(printf '%s\n' \
        "󰔎   Nightlight" \
        "󱫖   Idle Lock" \
        "󰍜   Top Bar" \
        "󱂬   Workspace Layout" \
        "   Window Gaps" \
        "   1-Window Ratio" \
        "󰍹   Display Scaling" \
    | rofi_menu)
    case "$CHOICE" in
        *Nightlight)         _toggle_nightlight ;;
        *"Idle Lock")        _toggle_idle_lock ;;
        *"Top Bar")          _toggle_waybar ;;
        *"Workspace Layout") _toggle_workspace_layout ;;
        *"Window Gaps")      _toggle_gaps ;;
        *"1-Window Ratio")   _toggle_one_window_ratio ;;
        *"Display Scaling")  _cycle_display_scaling ;;
    esac
}

# ── Toggle functions — delegate to hypr/scripts/ ─────────────────
_toggle_nightlight()       { bash "$HYPR_CONF/scripts/nightlight-toggle.sh" ; }
_toggle_idle_lock()        { bash "$HYPR_CONF/scripts/idle-toggle.sh" ; }
_toggle_waybar()           { bash "$HYPR_CONF/scripts/waybar-toggle.sh" ; }
_toggle_workspace_layout() { bash "$HYPR_CONF/scripts/workspace-layout-toggle.sh" ; }
_toggle_gaps()             { bash "$HYPR_CONF/scripts/window-gaps-toggle.sh" ; }
_toggle_one_window_ratio() { bash "$HYPR_CONF/scripts/one-window-ratio-toggle.sh" ; }
_cycle_display_scaling()   { bash "$HYPR_CONF/scripts/monitor-scaling-cycle.sh" ; }

# ── Style ────────────────────────────────────────────────────────
menu_style() {
    CHOICE=$(printf '%s\n' \
        "󰸌   Theme" \
        "   Font" \
        "   Background" \
        "   Hyprland" \
        "󰕢   Sddm Theme" \
    | rofi_menu)
    case "$CHOICE" in
        *Sddm*)      bash "$SCRIPTS/sddm-theme.sh" ;;
        *Theme)      bash "$SCRIPTS/theme-select.sh" ;;
        *Font)       menu_style_font ;;
        *Background) bash "$SCRIPTS/wallpaper-select.sh" ;;
        *Hyprland)   open_editor_kitty "󰸌 Hyprland Look" "$HYPR_CONF/looknfeel.conf" ;;
    esac
}

menu_style_font() {
    FONTS=$(bash "$HYPR_CONF/scripts/font-list.sh")
    CHOICE=$(echo "$FONTS" | rofi -dmenu -config "$ROFI_CONF/launcher-menu.rasi" -p "Choose a font" \
        -lines 10 -theme-str "listview { lines: 10; scrollbar: false; } window { width: 260px; }")
    [ -z "$CHOICE" ] && return
    bash "$HYPR_CONF/scripts/font-set.sh" "$CHOICE"
}

# ── Setup ────────────────────────────────────────────────────────
menu_setup() {
    CHOICE=$(printf '%s\n' \
        "   Audio" \
        "   Wifi" \
        "󰂯   Bluetooth" \
        "󱐋   Power Profile" \
        "   System Sleep" \
        "󰍹   Monitors" \
        "   Keybindings" \
        "   Input" \
        "   Config" \
    | rofi_menu)
    case "$CHOICE" in
        *Audio)           kitty --class "popup" --title "popup:audio" wiremix ;;
        *Wifi)            rfkill unblock wifi; kitty --class "popup" --title "popup:wifi" impala ;;
        *Bluetooth)       rfkill unblock bluetooth; kitty --class "popup" --title "popup:bluetooth" bluetui ;;
        *"Power Profile") menu_setup_power ;;
        *"System Sleep")  menu_setup_sleep ;;
        *Monitors)        open_editor_kitty "󰍹 Monitors" "$HYPR_CONF/monitors.conf" ;;
        *Keybindings)     open_editor_kitty "  Keybindings" "$HYPR_CONF/bindings.conf" ;;
        *Input)           open_editor_kitty "  Input" "$HYPR_CONF/input.conf" ;;
        *Config)          menu_setup_config ;;
    esac
}

menu_setup_power() {
    PROFILES=$(powerprofilesctl list | grep ':$' | sed 's/://;s/^ *//')
    local count
    count=$(echo "$PROFILES" | grep -c .)
    CHOICE=$(echo "$PROFILES" | rofi -dmenu -no-custom         -config "$ROFI_CONF/launcher-menu.rasi"         -p "Power Profile"         -lines "$count"         -theme-str "listview { lines: ${count}; } window { width: 260px; }")
    [ -z "$CHOICE" ] && return
    powerprofilesctl set "$CHOICE"
    notify-send "Power Profile" "Applied: $CHOICE"
}

menu_setup_sleep() {
    CHOICE=$(printf '%s\n' \
        "󰒲   Enable/Disable Suspend" \
        "󰤁   Enable Hibernate" \
        "󰤁   Disable Hibernate" \
    | rofi_menu)
    case "$CHOICE" in
        *"Enable/Disable Suspend") _toggle_suspend ;;
        *"Enable Hibernate")       _enable_hibernate ;;
        *"Disable Hibernate")      _disable_hibernate ;;
    esac
}

_toggle_suspend() {
    if systemctl is-enabled sleep.target &>/dev/null; then
        sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
        notify-send "System Sleep" "Sleep mode disabled"
    else
        sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
        notify-send "System Sleep" "Sleep mode enabled"
    fi
}

_enable_hibernate()  { sudo systemctl enable hibernate.target; notify-send "Hibernate" "Hibernate mode enabled"; }
_disable_hibernate() { sudo systemctl disable hibernate.target; notify-send "Hibernate" "Hibernate mode disabled"; }

menu_setup_config() {
    CHOICE=$(printf '%s\n' \
        "   Hyprland" \
        "󱫙   Hypridle" \
        "󰡀   Hyprlock" \
        "󰍜   Waybar" \
    | rofi_menu)
    case "$CHOICE" in
        *Hyprland) open_editor_kitty "  Hyprland" "$HYPR_CONF/hyprland.conf" ;;
        *Hypridle) kitty --class "popup" --title "popup:  Hypridle" sh -c "${EDITOR:-nvim} $HYPR_CONF/hypridle.conf; systemctl --user restart hypridle" ;;
        *Hyprlock) open_editor_kitty "  Hyprlock" "$HYPR_CONF/hyprlock.conf" ;;
        *Waybar)   kitty --class "popup" --title "popup:󰍜 Waybar" sh -c "${EDITOR:-nvim} $HOME/.config/waybar/config.jsonc; pkill waybar; waybar &" ;;
    esac
}

# ── Install ──────────────────────────────────────────────────────
menu_install() {
    CHOICE=$(printf '%s\n' \
        "󰣇   Package" \
        "󰣇   AUR" \
        "   Web App" \
        "   TUI" \
        "   Service" \
        "󰵮   Development" \
        "   Editor" \
        "   Terminal" \
        "󱚤   AI" \
        "󰍲   Windows" \
        "   Gaming" \
    | rofi_menu)
    case "$CHOICE" in
        *Package)     kitty --class "popup" --title "popup:󰣇 Install Package" bash "$SCRIPTS/pacman-installer.sh" ;;
        *AUR)         kitty --class "popup" --title "popup:󰣇 Install AUR"     bash "$SCRIPTS/aur-installer.sh" ;;
        *"Web App")   kitty --class "popup" --title "popup:󰗂 Install Web App" bash "$SCRIPTS/install/webapp-install" ;;
        *TUI)         kitty --class "popup" --title "popup:󰅵 Install TUI" bash "$SCRIPTS/install/tui-install" ;;
        *Service)     menu_install_service ;;
        *Development) menu_install_dev ;;
        *Editor)      menu_install_editor ;;
        *Terminal)    menu_install_terminal ;;
        *AI)          menu_install_ai ;;
        *Windows)     bash "$SCRIPTS/install/windows.sh" ;;
        *Gaming)      menu_install_gaming ;;
    esac
}


menu_install_service() {
    CHOICE=$(printf '%s\n' \
        "   Dropbox" \
        "   Tailscale" \
        "󱇱   NordVPN [AUR]" \
        "󰏖   ONCE" \
        "󰟵   Bitwarden" \
        "   Chromium Account" \
    | rofi_menu)
    case "$CHOICE" in
        *Dropbox)            bash "$SCRIPTS/install/dropbox.sh" ;;
        *Tailscale)          bash "$SCRIPTS/install/tailscale.sh" ;;
        *NordVPN)            kitty --class "popup" --title "popup:NordVPN" bash -c "yay -S nordvpn-bin; read" ;;
        *ONCE)               bash "$SCRIPTS/install/once.sh" ;;
        *Bitwarden)          bash "$SCRIPTS/install/bitwarden.sh" ;;
        *"Chromium Account") bash "$SCRIPTS/install/chromium-account.sh" ;;
    esac
}


menu_install_dev() {
    CHOICE=$(printf '%s\n' \
        "󰫏   Ruby on Rails" \
        "   Docker DB" \
        "   JavaScript" \
        "   Go" \
        "   PHP" \
        "   Python" \
        "   Elixir" \
        "   Zig" \
        "   Rust" \
        "   Java" \
        "   .NET" \
        "   OCaml" \
        "   Clojure" \
        "   Scala" \
    | rofi_menu)
    case "$CHOICE" in
        *"Ruby on Rails") bash "$SCRIPTS/install/dev/ruby.sh" ;;
        *"Docker DB")     bash "$SCRIPTS/install/dev/docker-db.sh" ;;
        *JavaScript)      menu_install_js ;;
        *Go)              bash "$SCRIPTS/install/dev/go.sh" ;;
        *PHP)             menu_install_php ;;
        *Python)          bash "$SCRIPTS/install/dev/python.sh" ;;
        *Elixir)          menu_install_elixir ;;
        *Zig)             bash "$SCRIPTS/install/dev/zig.sh" ;;
        *Rust)            bash "$SCRIPTS/install/dev/rust.sh" ;;
        *Java)            bash "$SCRIPTS/install/dev/java.sh" ;;
        *.NET)            bash "$SCRIPTS/install/dev/dotnet.sh" ;;
        *OCaml)           bash "$SCRIPTS/install/dev/ocaml.sh" ;;
        *Clojure)         bash "$SCRIPTS/install/dev/clojure.sh" ;;
        *Scala)           bash "$SCRIPTS/install/dev/scala.sh" ;;
    esac
}

menu_install_js() {
    CHOICE=$(printf '%s\n' \
        "   Node.js" \
        "   Bun" \
        "   Deno" \
    | rofi_menu)
    case "$CHOICE" in
        *Node*) bash "$SCRIPTS/install/dev/node.sh" ;;
        *Bun)   bash "$SCRIPTS/install/dev/bun.sh" ;;
        *Deno)  bash "$SCRIPTS/install/dev/deno.sh" ;;
    esac
}

menu_install_php() {
    CHOICE=$(printf '%s\n' \
        "   PHP" \
        "   Laravel" \
        "   Symfony" \
    | rofi_menu)
    case "$CHOICE" in
        *PHP)     bash "$SCRIPTS/install/dev/php.sh" ;;
        *Laravel) bash "$SCRIPTS/install/dev/laravel.sh" ;;
        *Symfony) bash "$SCRIPTS/install/dev/symfony.sh" ;;
    esac
}

menu_install_elixir() {
    CHOICE=$(printf '%s\n' \
        "   Elixir" \
        "   Phoenix" \
    | rofi_menu)
    case "$CHOICE" in
        *Elixir)  bash "$SCRIPTS/install/dev/elixir.sh" ;;
        *Phoenix) bash "$SCRIPTS/install/dev/phoenix.sh" ;;
    esac
}

menu_install_editor() {
    CHOICE=$(printf '%s\n' \
        "   VSCode" \
        "   Cursor" \
        "   Zed" \
        "   Sublime Text" \
        "   Helix" \
        "   Emacs" \
    | rofi_menu)
    case "$CHOICE" in
        *VSCode)  bash "$SCRIPTS/install/editors/vscode.sh" ;;
        *Cursor)  bash "$SCRIPTS/install/editors/cursor.sh" ;;
        *Zed)     bash "$SCRIPTS/install/editors/zed.sh" ;;
        *Sublime) bash "$SCRIPTS/install/editors/sublime.sh" ;;
        *Helix)   bash "$SCRIPTS/install/editors/helix.sh" ;;
        *Emacs)   bash "$SCRIPTS/install/editors/emacs.sh" ;;
    esac
}

menu_install_terminal() {
    CHOICE=$(printf '%s\n' \
        "󰄠   Alacritty" \
        "󰊠   Ghostty" \
        "󰄠   Kitty" \
    | rofi_menu)
    case "$CHOICE" in
        *Alacritty) kitty --class "popup" --title "popup:Install Alacritty" bash -c "sudo pacman -S alacritty; read" ;;
        *Ghostty)   bash "$SCRIPTS/install/terminals/ghostty.sh" ;;
        *Kitty)     kitty --class "popup" --title "popup:Install Kitty" bash -c "sudo pacman -S kitty; read" ;;
    esac
}

menu_install_ai() {
    CHOICE=$(printf '%s\n' \
        "   Dictation" \
        "󱚤   LM Studio" \
        "󱚤   Ollama" \
        "󱚤   Crush" \
    | rofi_menu)
    case "$CHOICE" in
        *Dictation)   bash "$SCRIPTS/install/ai/voxtype.sh" ;;
        *"LM Studio") bash "$SCRIPTS/install/ai/lmstudio.sh" ;;
        *Ollama)      bash "$SCRIPTS/install/ai/ollama.sh" ;;
        *Crush)       bash "$SCRIPTS/install/ai/crush.sh" ;;
    esac
}

menu_install_gaming() {
    CHOICE=$(printf '%s\n' \
        "   Steam" \
        "󰢹  NVIDIA GeForce NOW" \
        "   RetroArch [AUR]" \
        "󰍳󰍳  Minecraft" \
        "󰖺   Xbox Controller [AUR]" \
    | rofi_menu)
    case "$CHOICE" in
        *Steam)     kitty --class "popup" --title "popup:Install Steam" bash -c "sudo pacman -S steam; read" ;;
        *GeForce)   bash "$SCRIPTS/install/gaming/geforcenow.sh" ;;
        *RetroArch) kitty --class "popup" --title "popup:Install RetroArch" bash -c "yay -S retroarch libretro-meta; read" ;;
        *Minecraft) bash "$SCRIPTS/install/gaming/minecraft.sh" ;;
        *Xbox)      kitty --class "popup" --title "popup:Install Xbox Controller" bash -c "yay -S xboxdrv; read" ;;
    esac
}

# ── Remove ───────────────────────────────────────────────────────
menu_remove() {
    CHOICE=$(printf '%s\n' \
        "󰣇   Package" \
        "   Web App" \
        "   TUI" \
        "󰵮   Development" \
    | rofi_menu)
    case "$CHOICE" in
        *Package)     kitty --class "popup" --title "popup:󰭌 Remove Package" bash "$SCRIPTS/pkg-remove-tui.sh" remove ;;
        *"Web App")   kitty --class "popup" --title "popup:󰗂 Remove Web App" bash "$SCRIPTS/remove/webapp.sh" ;;
        *TUI)         kitty --class "popup" --title "popup:󰅵 Remove TUI" bash "$SCRIPTS/remove/tui-remove" ;;
        *Development) menu_remove_dev ;;
    esac
}

menu_remove_dev() {
    CHOICE=$(printf '%s\n' \
        "󰫏   Ruby on Rails" \
        "   JavaScript" \
        "   Go" \
        "   PHP" \
        "   Python" \
        "   Elixir" \
        "   Zig" \
        "   Rust" \
        "   Java" \
        "   .NET" \
        "   OCaml" \
        "   Clojure" \
        "   Scala" \
    | rofi_menu)
    case "$CHOICE" in
        *"Ruby on Rails") bash "$SCRIPTS/remove/dev/ruby.sh" ;;
        *JavaScript)      menu_remove_js ;;
        *Go)              bash "$SCRIPTS/remove/dev/go.sh" ;;
        *PHP)             menu_remove_php ;;
        *Python)          bash "$SCRIPTS/remove/dev/python.sh" ;;
        *Elixir)          menu_remove_elixir ;;
        *Zig)             bash "$SCRIPTS/remove/dev/zig.sh" ;;
        *Rust)            bash "$SCRIPTS/remove/dev/rust.sh" ;;
        *Java)            bash "$SCRIPTS/remove/dev/java.sh" ;;
        *.NET)            bash "$SCRIPTS/remove/dev/dotnet.sh" ;;
        *OCaml)           bash "$SCRIPTS/remove/dev/ocaml.sh" ;;
        *Clojure)         bash "$SCRIPTS/remove/dev/clojure.sh" ;;
        *Scala)           bash "$SCRIPTS/remove/dev/scala.sh" ;;
    esac
}

menu_remove_js() {
    CHOICE=$(printf '%s\n' "   Node.js" "   Bun" "   Deno" | rofi_menu)
    case "$CHOICE" in
        *Node*) bash "$SCRIPTS/remove/dev/node.sh" ;;
        *Bun)   bash "$SCRIPTS/remove/dev/bun.sh" ;;
        *Deno)  bash "$SCRIPTS/remove/dev/deno.sh" ;;
    esac
}

menu_remove_php() {
    CHOICE=$(printf '%s\n' "   PHP" "   Laravel" "   Symfony" | rofi_menu)
    case "$CHOICE" in
        *PHP)     bash "$SCRIPTS/remove/dev/php.sh" ;;
        *Laravel) bash "$SCRIPTS/remove/dev/laravel.sh" ;;
        *Symfony) bash "$SCRIPTS/remove/dev/symfony.sh" ;;
    esac
}

menu_remove_elixir() {
    CHOICE=$(printf '%s\n' "   Elixir" "   Phoenix" | rofi_menu)
    case "$CHOICE" in
        *Elixir)  bash "$SCRIPTS/remove/dev/elixir.sh" ;;
        *Phoenix) bash "$SCRIPTS/remove/dev/phoenix.sh" ;;
    esac
}

# ── Update ───────────────────────────────────────────────────────
menu_update() {
    CHOICE=$(printf '%s\n' \
        "󰋒   dotfiles" \
        "   Config" \
        "   Process" \
        "   Hardware" \
        "󰟵   Password" \
        "   Timezone" \
        "   Time" \
    | rofi_menu)
    case "$CHOICE" in
        *dotfiles) bash "$SCRIPTS/update/dotfiles.sh" ;;
        *Config)   menu_update_config ;;
        *Process)  menu_update_process ;;
        *Hardware) menu_update_hardware ;;
        *Password) menu_update_password ;;
        *Timezone) menu_update_timezone ;;
        *Time)     sudo hwclock --systohc; notify-send "Time" "Time updated" ;;
    esac
}

menu_update_config() {
    CHOICE=$(printf '%s\n' \
        "   Hyprland" \
        "󱫙   Hypridle" \
        "󰡀   Hyprlock" \
        "󰌧   rofi" \
        "󰍜   Waybar" \
    | rofi_menu)
    case "$CHOICE" in
        *Hyprland) bash "$SCRIPTS/update/config/hyprland.sh" ;;
        *Hypridle) bash "$SCRIPTS/update/config/hypridle.sh" ;;
        *Hyprlock) bash "$SCRIPTS/update/config/hyprlock.sh" ;;
        *rofi)     bash "$SCRIPTS/update/config/rofi.sh" ;;
        *Waybar)   bash "$SCRIPTS/update/config/waybar.sh" ;;
    esac
}

menu_update_process() {
    CHOICE=$(printf '%s\n' \
        "󱫙   Hypridle" \
        "󰖙   Hyprsunset" \
        "󰌧   rofi" \
        "󰍜   Waybar" \
    | rofi_menu)
    case "$CHOICE" in
        *Hypridle)   systemctl --user restart hypridle; notify-send "Hypridle" "Restarted" ;;
        *Hyprsunset) pkill hyprsunset; hyprsunset -t 4500 & notify-send "Hyprsunset" "Restarted" ;;
        *rofi)       pkill rofi; notify-send "rofi" "rofi restarted" ;;
        *Waybar)     pkill waybar; waybar & notify-send "Waybar" "Restarted" ;;
    esac
}

menu_update_hardware() {
    CHOICE=$(printf '%s\n' \
        "   Audio" \
        "   Wi-Fi" \
        "󰂯   Bluetooth" \
    | rofi_menu)
    case "$CHOICE" in
        *Audio)     systemctl --user restart pipewire pipewire-pulse; notify-send "Audio" "PipeWire restarted" ;;
        *Wi-Fi)     sudo systemctl restart NetworkManager; notify-send "Wi-Fi" "Network restarted" ;;
        *Bluetooth) sudo systemctl restart bluetooth; notify-send "Bluetooth" "Bluetooth restarted" ;;
    esac
}

menu_update_password() {
    CHOICE=$(printf '%s\n' "󰟵   User" | rofi_menu)
    case "$CHOICE" in
        *User) kitty --class "popup" --title "popup:Change Password" bash -c "passwd; read" ;;
    esac
}

menu_update_timezone() {
    TZ=$(timedatectl list-timezones \
        | rofi -dmenu -config "$ROFI_CONF/launcher-menu.rasi" -p "Choose timezone" \
        -lines 10 -theme-str "listview { lines: 10; scrollbar: false; } window { width: 260px; }")
    [ -z "$TZ" ] && return
    sudo timedatectl set-timezone "$TZ"
    notify-send "Timezone" "Applied: $TZ"
}

# ── About ────────────────────────────────────────────────────────
menu_about() {
    kitty --class "popup" --title "popup:  About" sh -c "fastfetch; read -n1 -s -r -p '\n Press any key to close...'"
}

# ── System ───────────────────────────────────────────────────────
menu_system() {
    bash "$HOME/.config/waybar/scripts/logout-menu.sh"
}

# ── Main ─────────────────────────────────────────────────────────
chosen=$(show_main)
[ -z "$chosen" ] && exit 0

case "$chosen" in
    *Apps)    menu_apps ;;
    *Learn)   menu_learn ;;
    *Trigger) menu_trigger ;;
    *Style)   menu_style ;;
    *Setup)   menu_setup ;;
    *Install) menu_install ;;
    *Remove)  menu_remove ;;
    *Update)  menu_update ;;
    *About)   menu_about ;;
    *System)  menu_system ;;
esac
