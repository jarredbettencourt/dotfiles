" This entire file has been addapted into lua and is now located in
" .config/nvim/init.lua. It may be worth it to redo this for backwards
" compatibility, and being able to use traditional vim on servers, but for now
" I am okay with doing this. If decided to use this file again, investigate if
" it will degrade performance to have lua do these options instead of
" vimscript.

" Enable relative and absolute line numbers
set number
set relativenumber

" Syntax highlighting
syntax on

" Enable mouse support
set mouse=a

" Don't show mode since the statusline shows it
set noshowmode

" Enable break indent
set breakindent

" Highlight the current line
set cursorline

" Keep 10 lines above/below the cursor when scrolling
set scrolloff=10

" Indentation settings
set tabstop=4
set shiftwidth=4
set autoindent
set smartindent
set softtabstop=4
set expandtab

" Persistent undo
set undofile

" Enable incremental search and highlight matches
set incsearch
set hlsearch

" Show partial commands in bottom right
set showcmd

set backspace=indent,eol,start " Intuitive backspace behavior.
set hidden                     " Possibility to have more than one unsaved buffers.
set ruler                      " Shows the current line number at the bottom-right
                               " of the screen.
set wildmenu                   " Great command-line completion, use `<Tab>` to move
                               " around and `<CR>` to validate.
                               "

" Don't add final newline to files
set nofixeol

" Show matching parentheses
set showmatch

" Set .j2 files to use HTML syntax
au BufNewFile,BufRead *.j2 set filetype=html

" Better completion experience
set completeopt=menu,menuone,noselect

" Disable backup, swap, and writebackup files
set noswapfile
set nobackup
set nowritebackup

" Enable 24-bit colors in terminal
set termguicolors

" Optional: add a color column at 80 characters (commented out)
" set colorcolumn=80

" Enable filetype plugins and indentation
filetype plugin indent on
