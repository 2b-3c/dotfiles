#!/bin/bash
# Wrapper — delegates to theme-set.sh (the ONYX theme engine)
# Usage: theme-select.sh <theme_name>
exec "$HOME/.config/hypr/scripts/theme-set.sh" "$@"
