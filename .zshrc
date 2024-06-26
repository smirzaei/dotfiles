# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="soroush"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git colored-man-pages golang kubectl)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Start ssh agent for agent forwarding
eval `ssh-agent -s`

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
