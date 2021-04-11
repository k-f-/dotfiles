# dots 

Your dotfiles are how you personalize your system. These are mine.
There are 3 branches for now: master, min & moar.

## min
Just what we need for some sane behaviors across various machines.

## moar
My local config on my 2011 mac-os 11' mba. fish, nvim, etc.

## master
Eventually, we'll probably just merge moar with master as I think 
min is in a pretty good spot.

## goals
* minimal configs
* linux first
* osx second
* just the things we use
* look into a better way to manage secrets?
---
I'm butchering this because I'm too busy trying to get things done.  
**TODO**
* symlink .vimrc -> .config/nvim/.vimrc (duh) consolidate.
* source a `.secrets` file.  
* Maybe give up on encFS, contents there are no less important than our SSH keys and we don't do fancy encrpytion for them.  Additionally, everything is ending up in our encFS drive which is both silly and a performance hit.  We already use WDE and assume it works.
* make `moar` default branch.
* fix Fish `lls` command.
* pbcopy and xcopy one-liner?
* Q: What is the most basic file type we can use to source in bash/zsh/fish?
* Q: Should we resort to GoPrompt? I hate how slow zsh/bash are with git-dirty.
* Q: I feel like vim/nvim is in a good place, should we look at emacs/spacemacs?
* Q: Mosh works so well, should I bother with tmux outside of rebinding to **c-a**?


## install

Run this:

```sh
git clone https://github.com/k-f-/dotfiles.git moar ~/.dotfiles
bash symlink
```

