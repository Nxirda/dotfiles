set nocompatible
set shell=/bin/bash
" Enable syntax highlighting
syntax enable

set encoding=utf-8
" Set tab size to 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nobackup
set incsearch
set ignorecase
set smartcase
set ttyfast

" " Enable line numbering
set number
set cursorline 
set nocursorcolumn

" Enable mouse support
set mouse=a

set background=dark
colorscheme iceberg


" TAB autocompletion menue
set wildmenu
set wildmode=list:longest
set wildignore=*.docx "insert more files to ignore"

" Enable file type detection
filetype on
filetype indent on
filetype plugin on

" Enable line wrapping
set wrap
" Highlight search results
set hlsearch
" Show matching parentheses
set showmatch
" Enable auto-indentation
set autoindent
" Enable smart indentation
set smartindent

" Auto-completion with CTRL-X CTRL-N
" set completeopt=menuone,preview

" Automatic parenthesis closing
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

set statusline=
set laststatus=2
" Set left part
set statusline+=\ %{mode()}\ %f\ %M\ %Y\ %R
" Separator
set statusline+=%=
" Set right part
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ %p%%

set noshowmode
set showcmd
set shortmess+=I

" VIM Script"
"Create an undo dir to undo even after closing vim"
if version >= 703
    set undodir=~/.vim/undodir
    set undofile 
    set undoreload=1000 
    "Numbers of lines here is short cause i 
    "dont handle large files
endif

augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline nocursorcolumn
augroup END

hi Comment cterm=italic ctermfg=gray ctermbg=none
