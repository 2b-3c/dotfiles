#!/bin/bash
OMARCHY_PATH="$HOME/.local/share/omarchy"
if [[ -d "$OMARCHY_PATH/.git" ]]; then
  git -C "$OMARCHY_PATH" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main"
else
  echo "main"
fi
