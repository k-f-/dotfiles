# -*- mode: sh -*-

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
# Explicitly unset color (default anyhow). Use 1 to set it.
GIT_PS1_SHOWCOLORHINTS=
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
# __git_ps1 reports "((unknown))" in directories with broken git
# repositories; unfortunately, pre-commit hooks are generally kept in
# an empty git repo in $HOME, resulting in unneeded grossness.
__quiet_git_ps1() {
  local b="$(__git_ps1)"
  if [ "$b" != " ((unknown))" ]; then
    echo -n "$b"
  fi
}

#export PS1='\[$(tput bold)\]\[\033[38;5;50m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;111m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] in \033[36m\]\w$(__quiet_git_ps1) \[\033[00m\]\n> \[$(tput sgr0)\]'

# rainbowsssss
export PS1='\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)]\]$(tput setaf 7)\]$(__quiet_git_ps1)\[$(tput sgr0)\] '

# Old
#PS1='\u@\h \[\033[36m\][\w$(__quiet_git_ps1)] \$ \[\033[00m\]'
