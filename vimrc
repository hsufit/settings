"we can use vim-plug to replace Vundle!!
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

"install vim with python support
"run install.py in install path
Plugin 'Valloric/YouCompleteMe'

Plugin 'mbbill/undotree'
"Plugin 'scrooloose/nerdtree' "nerdtree can somewhat be replaced by :h netrw
"Plugin 'vim-airline/vim-airline' "can be replaced by customized :h statusline

"Plugin 'dhruvasagar/vim-table-mode' "draw a good table
"Plugin 'hari-rangarajan/cctree'  "call tree, maybe YCM is sufficient
"Plugin 'mileszs/ack.vim'  "replace ack.vim by setting :h grepprg
"Plugin 'scrooloose/nerdcommenter'  "multi line comment tool
"Plugin 'SirVer/ultisnips'  "snippet driver, we can use vim-snippets with it.
call vundle#end()
filetype plugin indent on

set listchars=tab:>-,trail:-
set t_Co=256

"hightlight the cursorline 
set cursorline
hi CursorLine cterm=none ctermbg=DarkMagenta ctermfg=254
"set nocursorcolumn
set incsearch
set hlsearch
"set ignorecast
"highlight Search ctermbg=gray ctermfg=NONE "------need to change color

set relativenumber
set number


"set autoindent/smartindent/cindent
