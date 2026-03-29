# ─────────────────────────────────────────────────────────────────
#   .zshrc — Zsh Configuration
# ─────────────────────────────────────────────────────────────────

# ── Terminal Art ─────────────────────────────────────────────────
fastfetch

# ── PATH ─────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.cargo/bin"
export TERM=xterm-kitty

# ── Environment Variables ────────────────────────────────────────
export EDITOR=nvim
export XDG_CURRENT_DESKTOP=Hyprland
export XDG_SESSION_DESKTOP=Hyprland

# ── History ──────────────────────────────────────────────────────
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS       # لا تكرر الأوامر المتكررة
setopt HIST_IGNORE_ALL_DUPS   # احذف القديم إذا تكرر
setopt HIST_FIND_NO_DUPS      # لا تُظهر المكررات عند البحث
setopt HIST_SAVE_NO_DUPS      # لا تحفظ المكررات
setopt SHARE_HISTORY          # شارك التاريخ بين الجلسات
setopt APPEND_HISTORY         # أضف للتاريخ بدل الكتابة فوقه

# ── Zsh Options ──────────────────────────────────────────────────
setopt AUTO_CD                # اكتب اسم المجلد مباشرة للدخول إليه
setopt CORRECT                # صحح أخطاء الكتابة
setopt GLOB_DOTS              # اعرض الملفات المخفية في الـ glob
setopt EXTENDED_GLOB          # glob متقدم
setopt NO_BEEP                # أوقف الصوت

# ── Completions ──────────────────────────────────────────────────
autoload -Uz compinit
compinit -d ~/.cache/zcompdump

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
alias ga='git add'
alias gp='git push'
alias gl='git log --oneline --graph'

# System
alias update='yay -Syu'
alias f='lf'
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
