# Make sure history is saved
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

# Enable vi mode
bindkey -v

# Make sure homebrew installation is in PATH if we're running on mac
for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
  if [ -x "$brew_path" ]; then
    eval "$("$brew_path" shellenv)"
    break
  fi
done

### Autocomplete stuff
# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
[[ -d ~/.zsh/cache ]] || mkdir -p ~/.zsh/cache

# Completion settings
zstyle ':completion:*' menu select # Enable menu selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching

# Better completion display
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:corrections' format '%F{yellow}-- %d (errors: %e) --%f'

# Group matches and describe groups
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands

# Fuzzy matching of completions
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Auto-complete with dot files
_comp_options+=(globdots)

# Color completion suggestions
if (( ${+LS_COLORS} )); then
  zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
fi

# Git completions
if [[ -f ~/.zsh/git-completion.bash ]]; then
    zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
fi

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
if [[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    bindkey '^Y' autosuggest-accept
fi

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
if [[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
    source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Initialize completion system
autoload -Uz compinit && compinit

### FZF
# Check if fzf is installed
if command -v fzf >/dev/null 2>&1; then
    # Source fzf key bindings and completion
    if [[ -d /usr/share/fzf ]]; then
        # Linux
        source /usr/share/fzf/key-bindings.zsh
        source /usr/share/fzf/completion.zsh
    elif [[ -d /opt/homebrew/opt/fzf/shell ]]; then
        # macOS Homebrew (Apple Silicon)
        source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
        source /opt/homebrew/opt/fzf/shell/completion.zsh
    elif [[ -d /usr/local/opt/fzf/shell ]]; then
        # macOS Homebrew (Intel)
        source /usr/local/opt/fzf/shell/key-bindings.zsh
        source /usr/local/opt/fzf/shell/completion.zsh
    fi

    # Customize fzf appearance
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"

    # Use fd/ripgrep if available (faster than find)
    if command -v fd > /dev/null; then
        export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND='fd --type f --hidden --follow --exclude .git'
    fi

    # Preview file content using bat (if installed)
    if command -v bat > /dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    fi

    # Preview directory content using tree
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

    # fzf aliases
    alias fh='history | fzf'
    alias fk='kill -9 $(ps aux | fzf | awk "{print $2}")'
    alias fp='ps aux | fzf'
    alias ff='fzf --preview "bat --style=numbers --color=always --line-range :500 {}"'

    # Git + fzf
    alias gco='git checkout $(git branch | fzf)'
    alias glog='git log --oneline | fzf --preview "git show --color=always {1}"'
else
    echo "fzf is not installed"
fi

###


### Aliases
alias g=git
alias gst='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
###

# Start ssh agent for agent forwarding only if it's not already running
# Turns out sharing the same `.zshrc` file on multiple NixOS servers was not a
# great idea and this broke my agent forwarding.
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval `ssh-agent -s`
fi

export PATH="$PATH:$HOME/.local/bin/"

# Go: add GOPATH to PATH when Go exists
if command -v go >/dev/null 2>&1; then
  gopath="$(go env GOPATH 2>/dev/null)"
  if [[ -n "$gopath" ]]; then
    export PATH="$PATH:$gopath/bin"
  fi
fi

if [ -e ~/.machine_specific ];
then
  source ~/.machine_specific
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi


# K8s: enable completion when kubectl exists
if command -v kubectl >/dev/null 2>&1; then
  source <(kubectl completion zsh)
fi

if [ -e ~/.krew ];
then
    export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
fi

if [ -e ~/.cargo/bin ];
then
    export PATH="$PATH:$HOME/.cargo/bin"
fi

export GPG_TTY=$(tty)


# Flatpak stuff
if [ -e /var/lib/flatpak/exports/share ];
then
    export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi

if [ -e "$HOME/.local/share/flatpak/exports/share" ];
then
    export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
fi

