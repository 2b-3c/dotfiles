#!/bin/bash
VERSION_FILE="$HOME/.config/omarchy/version"
if [[ -f "$VERSION_FILE" ]]; then
  echo "Onyx $(cat "$VERSION_FILE")"
else
  echo "Onyx 1.0.0"
fi
