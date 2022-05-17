## Personal Dotfiles
#### 
- Mostly Doom Emacs & some bash via GNU Stow.
- History lives in tags prefixed with ```archive```.
- ymmv

### 2022-05-17
- new personal machine (macmini). Adding/cleaning/fixing
- ``topgrade`` is a nice utility.

### 2022-01-02
- I've started using Pop-OS as it solves both my nvidia and WM needs. 
I have no idea when ``stow`` changed.
- Track: ``stow {foo}``
- Load: ``stow --target="$HOME" --verbose=4 --ignore='^README.*' --dotfiles {foo}``
