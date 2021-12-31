#### FZF Exports
export FZF_PREVIEW_COMMAND="bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}"
export FZF_CTRL_T_OPTS="--min-height 30 --preview-window down:60% --preview-window noborder --preview '($FZF_PREVIEW_COMMAND) 2> /dev/null'"
#### Regular Stuff
export EDITOR="$HOME/.bin/em"
export TERMINAL="kitty"
export READER="envince"
export ALTERNATE_EDITOR="neovim"
#export BROWSER="google-chrome-stable"
export EMAIL="kyle@fring.io"
export GOPATH="/usr/bin"
export GPG_TTY=$(tty)
export HISTFILESIZE=20000
export HOMEBREW_NO_ANALYTICS=1
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export NAME="Kyle E. Fring"
export PROMPT_DIRTRIM=3
#### OS X Stop yelling at me for Bash, I know I'm a luddite.
export BASH_SILENCE_DEPRECATION_WARNING=1
