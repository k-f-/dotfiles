#[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# Point oh-my-zsh elsewhere for config.
ZSH_CUSTOM=$HOME/.zshrc.d


#ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}git%{$reset_color%}:%{$fg[red]%}"
#ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}…%{$reset_color%}"
#ZSH_THEME_GIT_PROMPT_CLEAN=""

#local prompt_jobs="%(1j.%{$fg[yellow]%}%j%{$reset_color%}%{$fg[red]%}z%{$reset_color%} .)"
#local prompt_host="%{$fg[cyan]%}%m%{$reset_color%}"
#local prompt_root="%(!.%{$fg_bold[red]%}#.%{$fg[green]%}$)%{$reset_color%}"

#local return_status="%{$fg[red]%}%(?..=)%{$reset_color%}"

#PROMPT='${prompt_jobs}${prompt_host}$(git_prompt_info) %~ ${prompt_root} '

#RPROMPT="${return_status}%*"
