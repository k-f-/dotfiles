pathmunge () {
  if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
    if [ "$2" = "after" ] ; then
      PATH=$PATH:$1
    else
      PATH=$1:$PATH
    fi
  fi
}

pathmunge /usr/local/sbin
pathmunge /usr/local/bin
pathmunge /sbin after
pathmunge $HOME/bin after
pathmunge $HOME/.bin after
pathmunge $HOME/.local/bin after
pathmunge $GOPATH/bin after
pathmunge /snap/bin after
pathmunge /Users/kef/Library/Python/3.11/bin
pathmunge $HOME/.emacs.d/bin after
pathmunge $HOME/.poetry/env after
pathmunge /opt/homebrew/bin after
pathmunge /opt/homebrew/opt/ruby/bin
export PATH
