# -*- mode: sh -*-

### ssh/mosh aliases
alias akita="mosh root@akita.kfring.com"

### BAT > CAT
### https://github.com/sharkdp/bat
### batcat because Ubuntu/Pop
alias cat="bat"
alias bat="batcat"

### Vim-->NeoVim
alias vim="nvim"

### Spotify was broken forever. Pop-OS fixes this. For posterity.
alias spotify-hdpi="spotify --force-device-scale-factor=2 &" # HiDPI flags.

###
alias chromedev="google-chrome-stable --disable-web-security --user-data-dir=/tmp &"

###
alias dc="docker-compose"
alias gg="git grep -n"
alias gs="git status -s"
alias gpg="gpg2"
alias less="less -R" # display colors correctly
alias sbcl="rlwrap sbcl"
alias lisp="sbcl --noinform"
alias lispi="sbcl -noinform --load"
alias la="ls -la"
alias ln="ln -v"
alias mkdir="mkdir -p"
alias myip="ip address | grep inet.*wlan0 | cut -d' ' -f6 | sed \"s/\/24//g\""
alias pbcopy="xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output"
alias speedtest='echo "scale=2; `curl  --progress-bar -w "%{speed_download}" http://speedtest.wdc01.softlayer.com/downloads/test10.zip -o /dev/null` / 131072" | bc | xargs -I {} echo {} mbps'
alias tree="tree -C" # add colors
alias ut="tar xavf"

### Package management
alias agi="sudo apt install"
alias agr="sudo apt remove"
alias acs="apt search"
alias agu="sudo apt update && sudo apt full-upgrade && sudo apt autoremove && sudo apt autoclean"
alias ali="apt-mark showmanual"
alias pkgcount="sudo dpkg-query -f '${binary:Package}\n' -W | wc -l"

alias oports="echo 'User:      Command:   Port:'; echo '----------------------------' ; lsof -i 4 -P -n | grep -i 'listen' | awk '{print \$3, \$1, \$9}' | sed 's/ [a-z0-9\.\*]*:/ /' | sort -k 3 -n |xargs printf '%-10s %-10s %-10s\n' | uniq"
alias serve="python -m SimpleHTTPServer"

### ls and grep
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
# some more ls aliases
alias ll='ls -alFh'
alias la='ls -Ah'
alias l='ls -CFh'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
