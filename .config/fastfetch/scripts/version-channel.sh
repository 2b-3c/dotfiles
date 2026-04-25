#!/bin/bash
if [[ -f /etc/pacman.d/mirrorlist ]] && grep -q "stable-mirror.omarchy.org" /etc/pacman.d/mirrorlist 2>/dev/null; then
  echo "stable"
elif [[ -f /etc/pacman.d/mirrorlist ]] && grep -q "rc-mirror.omarchy.org" /etc/pacman.d/mirrorlist 2>/dev/null; then
  echo "rc"
else
  echo "custom"
fi
