" My simple vim config file,
" nothing to fancy just using vim basic features as intended
" Might need some cleanup and refactoring so it s cleaner
set nocompatible
" set shell=/bin/bash

syntax enable

" So we have a window name beeing Vim 
set title
set titlestring=Vim

set encoding=utf-8

" Set tab size to 4 spaces
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set nobackup

set incsearch
set hlsearch

set ignorecase
set smartcase
set ttyfast

" QoL functions
set wrap
set showmatch
set autoindent
set smartindent
" Enable mouse support
set mouse=a

" Enable line numbering
set number
set cursorline 
set nocursorcolumn
set colorcolumn=80

set background=dark
colorscheme nxbox  

" TAB autocompletion menue
set wildmenu
set wildmode=list:longest
set wildignore=*.docx "insert more files to ignore"

" Command line area
set noshowmode
set showcmd
set shortmess+=F

" Enable file type detection
filetype on
filetype indent on
filetype plugin on

" Automatic parenthesis closing
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" Simple function to have a nvim like mode display
function! FullName()
    return   mode() ==# 'n' ? 'NORMAL '       : 
            \mode() ==# 'i' ? 'INSERT '       :
            \mode() ==# 'v' ? 'VISUAL '       :
            \mode() ==# 'R' ? 'REPLACE '      :
            \mode() ==# 'c' ? 'COMMAND LINE ' :
            \mode() ==# 't' ? 'TERMINAL '     : ''
endfunction

" Messy status line config 
highlight ModeBg      ctermfg=black ctermbg=yellow cterm=bold
highlight PlaceInfo   ctermfg=black ctermbg=yellow cterm=bold
highlight FileInfosBg ctermfg=green ctermbg=black  cterm=bold
highlight Transparent ctermbg=NONE

set statusline=
set laststatus=2
" Mode part
set statusline+=%#ModeBg#\ %{FullName()}
" File infos
set statusline+=%#FileInfosBg#\ %f\ %M\ %Y\ %R

set statusline+=%#Transparent#\ %{&fileformat}\ [%{&fileencoding}]\  
" Separator
set statusline+=%=
" Current char infos
set statusline+=ascii:\ %b\ hex:\ 0x%B
" Col/line infos
set statusline+=\ %#PlaceInfo#\ col:\%c\ line:\%l\/\%L\ [\%p\]%%\ %#NONE# 

" VIM Script 
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline nocursorcolumn  
augroup END


" Netrw config 
let g:netrw_winsize     = 15
let g:netrw_linestyle   = 3
let g:netrw_banner      = 0
let g:netrw_brows_split = 1
