# -*- mode: sh -*-

GIT_PS1_SHOWDIRTYSTATE=true

# __git_ps1 reports "((unknown))" in directories with broken git
# repositories; unfortunately, pre-commit hooks are generally kept in
# an empty git repo in $HOME, resulting in unneeded grossness.
__quiet_git_ps1() {
  local b="$(__git_ps1)"
  if [ "$b" != " ((unknown))" ]; then
    echo -n "$b"
  fi
}

PS1='\[$(tput bold)\]\[\033[38;5;50m\]\u\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\]@\[$(tput bold)\]\[$(tput sgr0)\]\[\033[38;5;111m\]\h\[$(tput sgr0)\]\[$(tput sgr0)\]\[\033[38;5;15m\] in \033[36m\]\w$(__quiet_git_ps1) \[\033[00m\]\n> \[$(tput sgr0)\]'
#PS1='\u@\h \[\033[36m\][\w$(__quiet_git_ps1)] \$ \[\033[00m\]'
