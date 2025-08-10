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

### Autocomplete stuff
# Load and initialize the completion system
autoload -Uz compinit
compinit

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Completion settings
zstyle ':completion:*' menu select # Enable menu selection
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # Case-insensitive matching
zstyle ':completion:*' completer _expand _complete _correct _approximate # Enable various completion features

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
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# Git completions
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

###

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

# Go
if ! command -v "go version" %> /dev/null; then
  export PATH=$PATH:/usr/local/go/bin
  if [[ "$(go env GOPATH)" ]]; then
    export PATH=$PATH:"$(go env GOPATH)/bin"
  else
    echo "go env GOPATH is empty"
  fi
else
  echo "go is not installed"
fi

eval "$(starship init zsh)"

if [ -e ~/.machine_specific ];
then
  source ~/.machine_specific
fi


export PATH="$PATH:$HOME/.local/bin/"

# K8s
# kubectl completion -h
if ! command -v "kubectl version" %> /dev/null; then
  source <(kubectl completion zsh)
else
  echo "kubectl is not installed"
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

