# ── PATH & Core Environment ───────────────────────────────────
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/metasploit-framework/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export LANG=en_US.UTF-8
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_ENV_HINTS=1
export OLLAMA_API_BASE="http://127.0.0.1:11434"

# Prevent Zsh from re-scanning PATH on every directory change
unsetopt auto_name_dirs

# ── History Settings ──────────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY       # Save exact timestamps
setopt SHARE_HISTORY          # Share history across tabs
setopt APPEND_HISTORY         # Append to history file
setopt HIST_EXPIRE_DUPS_FIRST # Delete duplicates first when full
setopt HIST_IGNORE_DUPS       # Ignore immediate duplicates
setopt HIST_REDUCE_BLANKS     # Clean up whitespace

# ── Antidote Plugin Manager ───────────────────────────────────
# Static Antidote plugin loading
zdir="${XDG_CACHE_HOME:-$HOME/.cache}/antidote"
zpath="$zdir/plugins.zsh"

# Ensure cache directory exists
mkdir -p "$zdir"

# Load antidote function from Homebrew or fallback path
if [[ -f /opt/homebrew/opt/antidote/share/antidote/antidote.zsh ]]; then
  source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
elif command -v brew >/dev/null 2>&1; then
  source "$(brew --prefix)/opt/antidote/share/antidote/antidote.zsh"
fi

# Generate static bundle if plugins file is newer than static script
if [[ ! -f "$zpath" || ~/.zsh_plugins.txt -nt "$zpath" ]]; then
  antidote bundle < ~/.zsh_plugins.txt >| "$zpath"
fi

# Source the compiled static bundle
[[ -f "$zpath" ]] && source "$zpath"

# ── History Substring Search Keybindings (Loaded Post-Plugins) ─
if widget-available history-substring-search-up 2>/dev/null || [ -n "$FUNCTIONS" ]; then
    bindkey '^[[A' history-substring-search-up 2>/dev/null
    bindkey '^[[B' history-substring-search-down 2>/dev/null
fi

# ── Zsh Vi Mode Configuration ────────────────────────────────
ZVM_CURSOR_STYLE_ENABLED=true
ZVM_KEYTIMEOUT=0.05  # Makes Esc key response instantaneous

# ── Smart Sudo (Double-tap Esc) ───────────────────────────────
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR + 5 ))
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# ── Editor ────────────────────────────────────────────────────
if command -v nvim &>/dev/null; then
    export EDITOR='nvim'
    export VISUAL='nvim'
else
    export EDITOR='zed'
    export VISUAL='zed'
fi

# ── Force Autosuggestion Styling ─────────────────────────────
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

# ── fzf (Fuzzy Finder) ────────────────────────────────────────
if command -v fzf &>/dev/null; then
    source <(fzf --zsh) 2>/dev/null
    bindkey -r '\ec'
    export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# ── Aliases — Listing ─────────────────────────────────────────
alias ls='eza --icons=always'
alias ll='eza -lAh --icons=always --git'
alias la='eza -A --icons=always'
alias lt='eza -lAht modified --icons=always'
alias l.='eza -d .* --icons=always'
alias cat='bat'

# ── Aliases — Brew ────────────────────────────────────────────
alias bi='brew install'
alias bcin='brew install --cask'
alias bui='brew uninstall'
alias bcuin='brew uninstall --cask'
alias clean='brew cleanup -s --prune=all'
alias bu='brew update'
alias bup='brew upgrade'
alias bdep="brew leaves"
alias bl='brew list'
alias bs='brew search'
alias binf='brew info'
alias bson='brew services start'
alias bsoff='brew services stop'

# ── Aliases — Git & Dotfiles ──────────────────────────────────
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias lg="lazygit"
alias gst='git status'
alias gd='git diff'
alias gl='git pull'
alias gp='git push'
alias gco='git checkout'
alias gb='git branch'
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# ── Aliases — Dev & System ────────────────────────────────────
alias py='python3'
alias v='nvim'
alias vim='nvim'
alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tk='tmux kill-session -t'
alias h='herder'
alias reload='exec zsh'
alias edit='zed ~/.zshrc'
alias awake='caffeinate -d'
alias c='clear'
alias path='echo $PATH | tr ":" "\n"'
alias update='bu && bup && clean'
alias upc='update && clean'
alias usage='ncdu --color dark -rr -x'
alias top='bottom'

# ── Bitwarden Shortcuts ───────────────────────────────────────
alias bwunlock='export BW_SESSION="$(bw unlock --raw)"'
alias bwget='bw get item'
alias bwpass='bw get password'

# ── Tool Integrations ─────────────────────────────────────────
command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

# Fast Node Manager (fnm)
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# ── Java Version Manager (jenv) ───────────────────────────────
export PATH="$HOME/.jenv/bin:$PATH"
jenv() {
  unset -f jenv java javac mvn gradle
  eval "$(command jenv init -)"
  jenv "$@"
}
java() { jenv; java "$@"; }
javac() { jenv; javac "$@"; }
mvn() { jenv; mvn "$@"; }
gradle() { jenv; gradle "$@"; }

# ─── Starship Prompt ───────────────────────────────────────────
command -v starship &>/dev/null && eval "$(starship init zsh)"

