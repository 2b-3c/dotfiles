#!/usr/bin/env bash

DESKTOP_DIR="$HOME/.local/share/applications"

# ── Filter Web Apps only (contain omarchy-launch-webapp or chromium --app) ──────
mapfile -t desktop_files < <(
    grep -rl "chromium --app\|omarchy-launch-webapp" "$DESKTOP_DIR" 2>/dev/null
)

clear
echo ""
echo -e "  \033[1m\033[38;5;214m󰗂  Remove Web App\033[0m"
echo "  ──────────────────────────────"
echo ""

if [[ ${#desktop_files[@]} -eq 0 ]]; then
    echo -e "  \033[38;5;245m No web applications installed\033[0m"
    echo ""
    read -n1 -s -rp "  Press any key to close..."
    exit 0
fi

# ── Build names list ────────────────────────────────────────────────────────
names=()
urls=()
files_map=()
for f in "${desktop_files[@]}"; do
    name=$(grep -m1 "^Name=" "$f" | cut -d= -f2-)
    url=$(grep -m1 "^Exec=" "$f" | grep -oP 'https?://[^ ]+' | head -1)
    [[ -n $name ]] && names+=("$name") && urls+=("${url:-}") && files_map+=("$f")
done

# ── fzf selection interface ────────────────────────────────────────────────────
fzf_args=(
  --prompt '󰗂  Web App: '
  --header 'Enter: Delete | Esc: Cancel'
  --pointer '▶'
  --color 'pointer:214,prompt:214,header:245,border:238'
  --border rounded
  --border-label '󰗂  Remove Web App'
  --border-label-pos top
  --padding '1,2'
  --margin '1,2'
  --info hidden
  --layout reverse
  --height '~50%'
)

chosen=$(printf '%s\n' "${names[@]}" | fzf "${fzf_args[@]}")

[[ -z $chosen ]] && exit 0

# ── Confirm deletion ───────────────────────────────────────────────────────────────
echo ""
echo -e "  \033[38;5;214m󰗑  Delete '\033[1m$chosen\033[0m\033[38;5;214m' ?\033[0m"
echo ""
read -rp "  [y/N]: " CONFIRM
[[ "$CONFIRM" =~ ^[Yy]$ ]] || exit 0

# ── Execute deletion ───────────────────────────────────────────────────────────────
for f in "${files_map[@]}"; do
    name=$(grep -m1 "^Name=" "$f" | cut -d= -f2-)
    if [[ "$name" == "$chosen" ]]; then
        icon=$(grep -m1 "^Icon=" "$f" | cut -d= -f2-)
        rm -f "$f"
        [[ -f "$icon" ]] && rm -f "$icon"
        break
    fi
done

echo ""
echo -e "  \033[38;5;76m  Removed:\033[0m \033[1m$chosen\033[0m"
sleep 1
