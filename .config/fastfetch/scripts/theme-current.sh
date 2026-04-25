#!/bin/bash
THEME_FILE="$HOME/.config/omarchy/current/theme.name"
if [[ -f $THEME_FILE ]]; then
  cat "$THEME_FILE" | sed -E 's/_/ /g; s/(^| )([a-z])/\1\u\2/g'
else
  echo "Unknown"
fi
