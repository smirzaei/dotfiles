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

bindkey '^Y' autosuggest-accept
bindkey -r '^U' # Make `C-u` do nothing.

export GPG_TTY=$(tty)

# Start ssh agent for agent forwarding only if it's not already running
# Turns out sharing the same `.zshrc` file on multiple NixOS servers was not a
# great idea and this broke my agent forwarding.
# if [ -z "$SSH_AUTH_SOCK" ]; then
#     eval `ssh-agent -s`
# fi

if [ -e ~/.machine_specific ];
then
  source ~/.machine_specific
fi

if [ -e ~/.krew ];
then
    export PATH="$PATH:${KREW_ROOT:-$HOME/.krew}/bin"
fi

# Flatpak stuff
if [ -e /var/lib/flatpak/exports/share ];
then
    export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
fi

if [ -e "$HOME/.local/share/flatpak/exports/share" ];
then
    export XDG_DATA_DIRS="$HOME/.local/share/flatpak/exports/share:$XDG_DATA_DIRS"
fi


