pathmunge () {
  case ":$PATH:" in
    *":$1:"*) ;;
    *)
      if [ "$2" = "after" ] ; then
        PATH=$PATH:$1
      else
        PATH=$1:$PATH
      fi
      ;;
  esac
}

pathmunge /usr/local/sbin
pathmunge /usr/local/bin
pathmunge /sbin after
pathmunge $HOME/bin after
pathmunge $HOME/.bin after
pathmunge $HOME/.local/bin after
pathmunge /snap/bin after
pathmunge /Users/kef/Library/Python/3.11/bin
pathmunge $HOME/.emacs.d/bin after
pathmunge $HOME/.poetry/env after
pathmunge /opt/homebrew/opt/ruby/bin

# Force Homebrew bin/sbin to the front so brew tools beat system /usr/bin
# equivalents (git, jq, python3, openssl, etc.). Strip any existing entries
# first because pathmunge would otherwise skip them.
PATH=":$PATH:"
PATH="${PATH//:\/opt\/homebrew\/bin:/:}"
PATH="${PATH//:\/opt\/homebrew\/sbin:/:}"
PATH="${PATH#:}"; PATH="${PATH%:}"
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

export PATH
