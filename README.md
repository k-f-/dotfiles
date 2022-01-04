## Personal Dotfiles
- I've started using Pop-OS as it solves both my nvidia and WM needs. 
- Mostly Doom Emacs & some bash via GNU Stow.
- History lives in tags prefixed with ```archive```.
- ymmv
### 2022-01-02
I have no idea when ``stow`` changed.
- Track: ``stow {foo}``
- Load: ``stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles {foo}``
