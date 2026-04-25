step "Step 2 — Hyprland window manager"

_install "Hyprland core" \
  hyprland hyprlock hypridle hyprsunset \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
  xorg-xwayland

_install "Wayland utilities" \
  grim slurp grimblast-git awww \
  wl-clipboard imagemagick iw

_install "Session & polkit" \
  hyprpolkitagent
