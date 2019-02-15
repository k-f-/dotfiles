source $HOME/.bin/git-completion.sh

export ALTERNATE_EDITOR=""
export BROWSER="brave-browser"
export EDITOR="$HOME/.bin/em"
export EMAIL="me@kfring.com"
export GOPATH="/usr/bin"
export GPG_TTY=$(tty)
export HISTFILESIZE=20000
export HOMEBREW_NO_ANALYTICS=1
export LANG="en_US"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export NAME="Kyle E. Fring"
export PROMPT_DIRTRIM=3

### local config settings, if any

if [ -e $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi
