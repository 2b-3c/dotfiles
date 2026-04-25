# ─────────────────────────────────────────────────────────────────
#   .zshrc — Zsh Configuration
# ─────────────────────────────────────────────────────────────────

# ── PATH ─────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export TERM=xterm-kitty

# ── Environment Variables ────────────────────────────────────────
export EDITOR=nvim
# Note: XDG_CURRENT_DESKTOP and XDG_SESSION_DESKTOP are set in hypr/env.conf

# ── History ──────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS       # Do not save duplicate commands
setopt HIST_IGNORE_ALL_DUPS   # Delete old entry if duplicated
setopt HIST_FIND_NO_DUPS      # Do not show duplicates when searching
setopt HIST_SAVE_NO_DUPS      # Do not save duplicates
setopt SHARE_HISTORY          # Share history between sessions
setopt APPEND_HISTORY         # Append to history instead of overwriting

# ── Zsh Options ──────────────────────────────────────────────────
setopt AUTO_CD                # Type directory name directly to enter it
setopt CORRECT                # Auto-correct typos
setopt GLOB_DOTS              # Show hidden files in glob patterns
setopt EXTENDED_GLOB          # Extended glob patterns
setopt NO_BEEP                # Disable beep sound

# ── Completions ──────────────────────────────────────────────────
autoload -Uz compinit
# Regenerate completion cache once per day only (speeds up shell startup)
if [[ -n ~/.cache/zcompdump(#qN.mh+24) ]]; then
    compinit -d ~/.cache/zcompdump
else
    compinit -C -d ~/.cache/zcompdump
fi

# Completions Styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*' squeeze-slashes true

# ── Keybindings ──────────────────────────────────────────────────
bindkey -e
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[[1;5A' history-substring-search-up    # Ctrl+Up
bindkey '^[[1;5B' history-substring-search-down  # Ctrl+Down
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^k' kill-line
bindkey '^H' backward-kill-word
bindkey '^J' history-search-forward
bindkey '^K' history-search-backward
bindkey '^R' fzf-history-widget
bindkey '^[[3~' delete-char                      # Delete key
bindkey '^[[H' beginning-of-line                 # Home key
bindkey '^[[F' end-of-line                       # End key

# ── Aliases ──────────────────────────────────────────────────────
# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# File listing
alias ls='lsd'
alias lsa='lsd -A'
alias ll='lsd -lA'
alias lt='lsd --tree'

# Editors
alias v='nvim'
alias zshconf='$EDITOR ~/.zshrc && source ~/.zshrc'

# Git
alias gc='git clone'
alias gs='git status'
alias gp='git push'
alias gl='git log --oneline --graph'

# System
alias update='yay -Syu'
alias f='yazi'
alias cat='bat'
alias grep='grep --color=auto'

# Hyprland
alias hyprconf='$EDITOR ~/.config/hypr/hyprland.conf'
alias waybarconf='$EDITOR ~/.config/waybar/config.jsonc'

# ── FZF Configuration ────────────────────────────────────────────
export FZF_DEFAULT_OPTS='
  --height 40%
  --layout=reverse
  --border
  --preview "bat --color=always --style=numbers {} 2>/dev/null || ls -la {}"
  --preview-window=right:50%
'
export FZF_CTRL_T_OPTS="--preview 'bat --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'lsd --tree --color=always {}'"

# ── Shell Integrations ───────────────────────────────────────────
eval "$(starship init zsh)"

# ── Starship live reload on theme change ─────────────────────────
# Checks if starship.toml was modified since last prompt; if so, reloads it
_STARSHIP_TOML="$HOME/.config/starship.toml"
_STARSHIP_MTIME=0
_starship_reload_if_changed() {
    local mtime
    mtime=$(stat -c %Y "$_STARSHIP_TOML" 2>/dev/null) || return
    if [[ "$mtime" != "$_STARSHIP_MTIME" ]]; then
        _STARSHIP_MTIME=$mtime
        eval "$(starship init zsh)"
    fi
}
precmd_functions+=(_starship_reload_if_changed)
eval "$(zoxide init zsh --cmd cd)"
eval "$(fzf --zsh)"

# ── Plugins ──────────────────────────────────────────────────────
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# Autosuggestions config
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ── Colorscheme (Pywal) ──────────────────────────────────────────
if [[ -f ~/.cache/wal/sequences ]]; then
    (cat ~/.cache/wal/sequences &)
    source ~/.cache/wal/colors-tty.sh 2>/dev/null || true
fi

# ── Git Worktrees ─────────────────────────────────────────────────
# Create a new worktree and branch from current git directory
ga() {
    if [[ -z "$1" ]]; then echo "Usage: ga [branch name]"; return 1; fi
    local branch="$1"
    local base="$(basename "$PWD")"
    local wt_path="../${base}--${branch}"
    git worktree add -b "$branch" "$wt_path"
    cd "$wt_path"
}

# Remove worktree and branch from within active worktree
gd() {
    local cwd="$(pwd)"
    local worktree="$(basename "$cwd")"
    local root="${worktree%%--*}"
    local branch="${worktree#*--}"
    if [[ "$root" != "$worktree" ]]; then
        read -q "REPLY?Remove worktree and branch '$branch'? [y/N] " && echo
        if [[ "$REPLY" =~ ^[Yy]$ ]]; then
            cd "../$root"
            git worktree remove "$cwd" --force || return 1
            git branch -D "$branch"
        fi
    else
        echo "Not inside a worktree directory"
    fi
}

# ── SSH Port Forwarding ───────────────────────────────────────────
# Forward ports: fip <host> <port1> [port2] ...
fip() {
    (( $# < 2 )) && echo "Usage: fip <host> <port1> [port2] ..." && return 1
    local host="$1"; shift
    for port in "$@"; do
        ssh -f -N -L "${port}:localhost:${port}" "$host" && echo "Forwarding localhost:$port → $host:$port"
    done
}

# Drop port forward: dip <port1> [port2] ...
dip() {
    (( $# == 0 )) && echo "Usage: dip <port1> [port2] ..." && return 1
    for port in "$@"; do
        pkill -f "ssh.*-L $port:localhost:$port" && echo "Stopped $port" || echo "No forwarding on port $port"
    done
}

# List active port forwards
lip() {
    pgrep -af "ssh.*-L [0-9]+:localhost:[0-9]+" || echo "No active forwards"
}

# ── Compression helpers ───────────────────────────────────────────
compress()    { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress='tar -xzf'

# ── Tmux Dev Layout ───────────────────────────────────────────────
# Usage: tdl <ai_command>
# Creates: nvim (left) + AI (right 30%) + terminal (bottom 15%)
tdl() {
    [[ -z $1 ]] && { echo "Usage: tdl <ai_command>"; return 1; }
    [[ -z $TMUX ]] && { echo "Start tmux first"; return 1; }
    local current_dir="${PWD}"
    local editor_pane="$TMUX_PANE"
    local ai="$1"
    tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
    tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
    local ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai_pane" "$ai" C-m
    tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
    tmux select-pane -t "$editor_pane"
}
