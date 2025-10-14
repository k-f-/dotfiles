# Source git completion if available
[[ -f "$HOME/.bin/git-completion.sh" ]] && source "$HOME/.bin/git-completion.sh"

### local config settings, if any
if [ -e $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi
