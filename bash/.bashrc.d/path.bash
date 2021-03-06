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
pathmunge $HOME/.emacs.d/bin after
pathmunge $HOME/.poetry/env after
export PATH
