
#[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$ZSH/custom"
export GPG_TTY=$(tty)

# Disable oh-my-zsh theme - we use custom prompt below
ZSH_THEME=""

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

# Better history settings
HISTSIZE=50000                   # How many lines in memory
SAVEHIST=50000                   # How many lines to save to file
setopt EXTENDED_HISTORY          # Record timestamp of command
setopt HIST_EXPIRE_DUPS_FIRST    # Delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_FIND_NO_DUPS         # Don't display duplicates when searching
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new is duplicate
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries
setopt SHARE_HISTORY             # Share history between all sessions


# Turn off all beeps
unsetopt BEEP
# Turn off autocomplete beeps
unsetopt LIST_BEEP

# Install oh-my-zsh plugins if missing
[ ! -d $ZSH_CUSTOM/plugins/zsh-autosuggestions ] && \
	git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

[ ! -d $ZSH_CUSTOM/plugins/zsh-completions ] && \
	git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions

[ ! -d $ZSH_CUSTOM/plugins/fast-syntax-highlighting ] && \
	git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

[ ! -d $ZSH_CUSTOM/plugins/zsh-history-substring-search ] && \
	git clone https://github.com/zsh-users/zsh-history-substring-search.git $ZSH_CUSTOM/plugins/zsh-history-substring-search

## PLUGINS CONFIG
plugins=(
  docker
  docker-compose
  git
  zsh-autosuggestions
  zsh-completions
  fast-syntax-highlighting
  zsh-history-substring-search
  macos
)

# Source OH-MY-ZSH so it loads at all.
source $ZSH/oh-my-zsh.sh

source <(fzf --zsh)

# ============================================================================
# Enhanced History & Editing Configuration
# ============================================================================

# Better history search - type partial command and use up/down arrows
# This searches for commands that START with what you've typed
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

# Alternative: Ctrl+R for fzf history search (already enabled by fzf --zsh)
# But let's make Ctrl+R even better with preview
export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

# Edit command in your $EDITOR with Ctrl+X Ctrl+E
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# Ctrl+U: Kill line backwards (useful for clearing multi-line commands)
bindkey '^u' backward-kill-line

# Ctrl+K: Kill line forwards
bindkey '^k' kill-line

# Alt+Backspace: Delete word backwards (more intuitive on mac)
bindkey '^[^?' backward-kill-word

# Better word movement
bindkey '^[[1;5C' forward-word      # Ctrl+Right
bindkey '^[[1;5D' backward-word     # Ctrl+Left
bindkey '^[^[[C' forward-word       # Alt+Right (alternate)
bindkey '^[^[[D' backward-word      # Alt+Left (alternate)

# ============================================================================
# Autosuggestions Configuration
# ============================================================================

# Configure zsh-autosuggestions for better behavior
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Accept suggestion with Ctrl+Space or End key
bindkey '^ ' autosuggest-accept      # Ctrl+Space
bindkey '^[[F' autosuggest-accept    # End key

# Accept just one word of suggestion with Ctrl+Right or Alt+F
bindkey '^[[1;5C' forward-word                    # Ctrl+Right (also moves forward)
bindkey '^[f' vi-forward-word                     # Alt+F


# Enable prompt substitution and zsh vcs info for git
setopt PROMPT_SUBST
autoload -Uz vcs_info

# Configure vcs_info for git with detailed status
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '%F{yellow}●%f'     # Yellow dot for unstaged changes
zstyle ':vcs_info:*' stagedstr '%F{green}●%f'        # Green dot for staged changes

# Format strings - basic and during actions (merge, rebase, etc.)
zstyle ':vcs_info:git:*' formats ' %F{blue}git%f:%F{red}%b%f%u%c%m'
zstyle ':vcs_info:git:*' actionformats ' %F{blue}git%f:%F{red}%b%f|%F{yellow}%a%f%u%c%m'

# Enable custom git status hooks
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked git-stash git-remotebranch

# Hook: Show indicator for untracked files
+vi-git-untracked() {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
       git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        hook_com[staged]+="%F{red}●%f"  # Red dot for untracked files
    fi
}

# Hook: Show stash indicator
+vi-git-stash() {
    local -a stashes
    if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
        stashes=$(git stash list 2>/dev/null | wc -l | tr -d ' ')
        hook_com[misc]+="%F{cyan}⚑${stashes}%f"  # Cyan flag with count
    fi
}

# Hook: Show remote tracking branch status (ahead/behind)
+vi-git-remotebranch() {
    local ahead behind
    local -a gitstatus

    # Check if we're in a git repo
    [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]] && return

    # Get ahead/behind counts
    local remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

    if [[ -n ${remote_branch} ]] ; then
        ahead=$(git rev-list ${remote_branch}..HEAD 2>/dev/null | wc -l | tr -d ' ')
        behind=$(git rev-list HEAD..${remote_branch} 2>/dev/null | wc -l | tr -d ' ')

        if [[ $ahead -gt 0 ]] ; then
            gitstatus+="%F{green}↑${ahead}%f"
        fi
        if [[ $behind -gt 0 ]] ; then
            gitstatus+="%F{red}↓${behind}%f"
        fi

        hook_com[misc]+="${(j::)gitstatus}"
    fi
}

# Hook to run vcs_info before each prompt
precmd() {
    vcs_info
}

# Prompt components (properly wrapped for zero-width)
prompt_jobs="%(1j.%{$fg[yellow]%}%j%{$reset_color%}%{$fg[red]%}z%{$reset_color%} .)"
prompt_host="%{$fg[cyan]%}%m%{$reset_color%}"
prompt_dir="%{$fg[blue]%}%~%{$reset_color%}"
prompt_char="%(!.%{$fg_bold[red]%}#.%{$fg[green]%}$)%{$reset_color%}"

# Return status for right prompt
prompt_return_status="%{$fg[red]%}%(?..=)%{$reset_color%}"

# Main prompt - use vcs_info_msg_0_ which is properly formatted for zsh line editor
PROMPT='${prompt_jobs}${prompt_host}${vcs_info_msg_0_} ${prompt_dir} ${prompt_char} '

# Right prompt with time
RPROMPT='${prompt_return_status}%*'

# Turn on zsh-autosuggestions
fpath=($ZSH_HOME/zsh-completions/src $fpath)

# Load supplementary scripts
source ~/.bashrc.d/aliases.bash
source ~/.bashrc.d/exports.bash
source ~/.bashrc.d/variables.bash
source ~/.bashrc.d/utils.bash
source ~/.bashrc.d/path.bash

# bun completions
[ -s "/Users/kef/.bun/_bun" ] && source "/Users/kef/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
