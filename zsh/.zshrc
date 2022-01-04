
#[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.zshrc.d"
export GPG_TTY=$(tty)

DISABLE_UPDATE_PROMPT="true"
# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"
# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"
# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"
# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="yyyy-mm-dd"
HIST_IGNORE_DUPS=true
HIST_IGNORE_SPACE=true


# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
unsetopt LIST_BEEP

## PLUGINS CONFIG
#

plugins=(
  docker
  docker-compose
  git
  zsh-autosuggestions
  zsh-completions
  fast-syntax-highlighting
  macos
)

source $ZSH/oh-my-zsh.sh

[ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ] && \
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

[ ! -d $ZSH_CUSTOM/plugins/zsh-completions ] && \
	git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions

[ ! -d $ZSH_CUSTOM/plugins/fast-syntax-highlighting ] && \
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting


# Point oh-my-zsh elsewhere for config.
ZSH_CUSTOM=$HOME/.zshrc.d


ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue]%}git%{$reset_color%}:%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%}…%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

local prompt_jobs="%(1j.%{$fg[yellow]%}%j%{$reset_color%}%{$fg[red]%}z%{$reset_color%} .)"
local prompt_host="%{$fg[cyan]%}%m%{$reset_color%}"
local prompt_root="%(!.%{$fg_bold[red]%}#.%{$fg[green]%}$)%{$reset_color%}"

local return_status="%{$fg[red]%}%(?..=)%{$reset_color%}"

PROMPT='${prompt_jobs}${prompt_host}$(git_prompt_info) %~ ${prompt_root} '

RPROMPT="${return_status}%*"
