#!/bin/bash
# ══════════════════════════════════════════════════════════════════
#   migrate.sh — ONYX Migration Runner
#   Runs any pending migrations from ~/dotfiles/migrations/
#   Tracks completed migrations in ~/.local/state/onyx/migrations/
# ══════════════════════════════════════════════════════════════════

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../" && pwd)"
MIGRATIONS_DIR="$DOTFILES_DIR/migrations"
STATE_DIR="$HOME/.local/state/onyx/migrations"
mkdir -p "$STATE_DIR" "$STATE_DIR/skipped"

if [[ ! -d "$MIGRATIONS_DIR" ]]; then
  echo "No migrations directory found at $MIGRATIONS_DIR"
  exit 0
fi

for file in "$MIGRATIONS_DIR"/*.sh; do
  [[ -f "$file" ]] || continue
  filename=$(basename "$file")

  if [[ ! -f "$STATE_DIR/$filename" && ! -f "$STATE_DIR/skipped/$filename" ]]; then
    echo -e "\e[32m\nRunning migration (${filename%.sh})\e[0m"

    if bash "$file"; then
      touch "$STATE_DIR/$filename"
    else
      echo -e "\e[31mMigration failed: $filename\e[0m"
      if command -v gum &>/dev/null; then
        if gum confirm "Migration ${filename%.sh} failed. Skip and continue?"; then
          touch "$STATE_DIR/skipped/$filename"
        else
          exit 1
        fi
      else
        echo "Skipping failed migration and continuing..."
        touch "$STATE_DIR/skipped/$filename"
      fi
    fi
  fi
done

echo -e "\e[32m✓ All migrations up to date\e[0m"
