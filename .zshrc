# ── PATH & Environment ────────────────────────────────────────
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/metasploit-framework/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

export LANG=en_US.UTF-8
export HOMEBREW_NO_ENV_HINTS=1
export OLLAMA_API_BASE="http://127.0.0.1:11434"

# Prevent Zsh from re-scanning PATH on every directory/subshell change
unsetopt auto_name_dirs

# ── Global History Setup ──────────────────────────────────────
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# ── Advanced Zsh History Settings ────────────────────────────
setopt EXTENDED_HISTORY       # Save exact timestamps for commands
setopt SHARE_HISTORY          # Share history across all open tabs instantly
setopt APPEND_HISTORY         # Append history entries instead of replacing them
setopt HIST_EXPIRE_DUPS_FIRST # Delete oldest duplicate entries first when full
setopt HIST_IGNORE_DUPS       # Do not record a command if it was the exact previous one
setopt HIST_REDUCE_BLANKS     # Clean up unnecessary whitespace from saved entries

# ── Antidote Plugin Manager ───────────────────────────────────
source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load

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

# ── History Substring Search Keybindings ─────────────────────
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ── Smart Text Editing Keybindings ───────────────────────────
bindkey '^B' backward-word         # Ctrl + B: Jump back one word
bindkey '^F' forward-word          # Ctrl + F: Jump forward one word
bindkey '^A' beginning-of-line     # Ctrl + A: Jump to start of line
bindkey '^E' end-of-line           # Ctrl + E: Jump to end of line
bindkey '^?' backward-delete-char  # Backspace deletes character

# ── Smart Sudo (Double-tap Esc to prepend sudo) ───────────────
sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER != sudo\ * ]]; then
        BUFFER="sudo $BUFFER"
        CURSOR=$(( CURSOR + 5 ))
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

# ── fzf (fuzzy finder) ────────────────────────────────────────
source <(fzf --zsh) 2>/dev/null
bindkey -r '\ec'

autoload -U fzf-file-widget fzf-cd-widget
zle -N fzf-file-widget
zle -N fzf-cd-widget

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

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

# ── Aliases — Git ─────────────────────────────────────────────
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

# ── Aliases — Dev & Editors ───────────────────────────────────
alias py='python3'
alias v='nvim'
alias vim='nvim'

# ── Aliases — Tmux & Herder ───────────────────────────────────
alias t='tmux'
alias ta='tmux attach -t'
alias tls='tmux list-sessions'
alias tk='tmux kill-session -t'
alias h='herder'

# ── Aliases — System ──────────────────────────────────────────
alias reload='exec zsh'
alias edit='zed ~/.zshrc'
alias awake='caffeinate -d'
alias c='clear'
alias path='echo $PATH | tr ":" "\n"'
alias update='bu && bup && clean'
alias upc='update && clean'

# ── Aliases — Tools ───────────────────────────────────────────
alias usage='ncdu --color dark -rr -x'
alias top='bottom'

# ── Tool Integrations ─────────────────────────────────────────
eval "$(zoxide init zsh)"

# ── Fast Node Manager (fnm) ─────────────────────────────────── 
if command -v fnm &>/dev/null; then
  eval "$(fnm env --use-on-cd)"
fi

# ── SDKMAN! (Java Manager) ────────────────────────────────────
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# ── Starship Prompt (Must be initialized last) ───────────────
eval "$(starship init zsh)"

# ── Export ───────────────────────────────────────────────────
export HOMEBREW_NO_AUTOUPDATE=1

