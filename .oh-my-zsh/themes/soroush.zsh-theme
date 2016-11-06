# help: http://www.nparikh.org/unix/prompt.php

local ret_status="%(?:%{$fg_bold[green]%}λ :%{$fg_bold[red]%}λ %s)"
PROMPT='%n@%m: %{$fg_bold[yellow]%}%~ %{$fg_bold[blue]%}$(git_prompt_info)
${ret_status}$reset_color'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[magenta][%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[magenta]%}] %{$fg_bold[red]%}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[magenta]%}]"
