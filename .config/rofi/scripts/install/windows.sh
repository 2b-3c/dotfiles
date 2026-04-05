#!/usr/bin/env bash
kitty --class "popup" --title "popup:Install Windows VM" bash -c "
    sudo pacman -S --noconfirm qemu-full virt-manager libvirt dnsmasq
    sudo systemctl enable --now libvirtd
    sudo usermod -aG libvirt \$USER
    notify-send 'Windows VM' '✓ QEMU/KVM ready — open virt-manager to create the virtual machine'
    echo ''
    echo 'Installed: qemu-full, virt-manager, libvirt'
    echo 'Open virt-manager and create a new virtual machine'
    read -n1 -s -rp 'Press any key to close...'
"
