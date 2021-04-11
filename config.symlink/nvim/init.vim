" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Initialize plugin system
call plug#end()

" vim-airline powerline fonts
let g:airline_powerline_fonts = 1

" color schemes
let g:airline_theme='dracula'
colorscheme dracula
" dracula theme bg color broke 04/04/2018
let g:dracula_colorterm = 0

"####   GENERAL                 ###############################################
set backspace=indent,eol,start  " Backspace behaviour
set ruler                       " Give me some info
set virtualedit=onemore         " Give me one character after EOL
syntax on                       " Syntax Highlighting
set tabstop=4 softtabstop=-1 shiftwidth=0 expandtab
set nowrap                      " Don't wrap
set smartindent                 " Smart Indent
set hlsearch                    " highlight searches
set showmatch                   " show match count
set ignorecase smartcase        " be smart w/ case
set autoread                    " reload open files
set incsearch
set number                      " line #'s
set showmatch                   " show matching parenthesis
set shortmess+=I                " Disable short message shown at start

