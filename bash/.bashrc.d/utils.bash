# -*- mode: sh -*-
function usage() {
  du -sch "$@" | sort -h
}

function countpage() {
  pdf2dsc "$1" /dev/stdout | grep "Pages" | sed s/[^0-9]//g
}

function path() {
  echo $PATH | tr ':' '\n'
}
