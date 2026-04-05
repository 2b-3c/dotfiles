#!/bin/bash
LAST=$(grep "upgraded" /var/log/pacman.log 2>/dev/null | tail -1 | sed -E 's/\[([^]]+)\].*/\1/')
if [[ -n "$LAST" ]]; then
  date -d "$LAST" "+%A, %B %d %Y at %H:%M" 2>/dev/null || echo "$LAST"
else
  echo "Never"
fi
