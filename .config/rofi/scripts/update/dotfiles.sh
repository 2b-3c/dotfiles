#!/bin/bash
# Update dotfiles from remote repo

DOTFILES="$HOME/dotfiles"

# Check if dotfiles directory exists
if [ ! -d "$DOTFILES" ]; then
    notify-send -u critical "dotfiles" "Directory not found: $DOTFILES"
    exit 1
fi

# Check if it's a git repo
if [ ! -d "$DOTFILES/.git" ]; then
    notify-send -u critical "dotfiles" "Not a git repository: $DOTFILES"
    exit 1
fi

cd "$DOTFILES" || exit 1

# Check for internet connection
if ! ping -c 1 github.com &>/dev/null; then
    notify-send -u critical "dotfiles" "No internet connection"
    exit 1
fi

# Fetch and check if there are updates
git fetch origin

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse @{u} 2>/dev/null)

if [ "$LOCAL" = "$REMOTE" ]; then
    notify-send "dotfiles" "✓ Files are already up to date"
    exit 0
fi

# Pull updates
OUTPUT=$(git pull origin 2>&1)

if [ $? -eq 0 ]; then
    notify-send "dotfiles" "✓ Updated successfully"
else
    notify-send -u critical "dotfiles" "Update failed:\n$OUTPUT"
    exit 1
fi
