#!/bin/bash
# Returns button label based on current battery mode
if ! command -v powerprofilesctl &>/dev/null; then
    echo "false"
    exit
fi

CURRENT=$(powerprofilesctl get 2>/dev/null || echo "balanced")

case "$CURRENT" in
    "performance")  echo "true"  ;;   # active = performance
    "balanced")     echo "true"  ;;   # active = normal
    "power-saver")  echo "false" ;;   # inactive = saving
esac
