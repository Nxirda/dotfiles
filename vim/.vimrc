" My simple vim config file,
" nothing to fancy just using vim basic features as intended
" Might need some cleanup and refactoring so it s cleaner
set nocompatible

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
set smarttab
set smoothscroll

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
set termguicolors

colorscheme mocha 

" TAB autocompletion menue
set wildmenu
set wildoptions=fuzzy
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

" Set up tabline and status line
set showtabline=1
set laststatus=2

" VIM Script 
augroup cursor_off
    autocmd!
    autocmd WinLeave * set nocursorline nocursorcolumn
    autocmd WinEnter * set cursorline nocursorcolumn
augroup END

function! ActiveStatusLine()
    let statusline = ''
    " Mode part
    let statusline .= '%#ModeBg# %{FullName()}'
    " File info
    let statusline .= '%#FileInfosBg# %f %M %Y %R'
    " File format and encoding
    let statusline .= '%#Transparent# %{&fileformat} [%{&fileencoding}]'
    " Separator
    let statusline .= '%='
    " Current char info
    let statusline .= 'ascii: %b hex: 0x%B'
    " Col/line info
    let statusline .= ' %#PlaceInfo# col:%c line:%l/%L [%p]%% %#NONE#'
    return statusline
endfunction

" maybe show lines and cols ?"
" Function for the inactive window status line
function! InactiveStatusLine()
    let statusline = ''
    let statusline = "%#InactiveColor# %f [%{&fileencoding}]"
    return statusline
endfunction

augroup status_line
    autocmd!
    autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatusLine()
    autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatusLine()
augroup end

"Split pane things : care the splitters are special chars not | and - 
set fillchars+=vert:┃
set fillchars+=eob:~

function CustomTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return fnamemodify(bufname(buflist[winnr -1]), ':t') " Get filename only
endfunction

" To fix it s actually stackoverflow thing"
function! GlobalTabLine()
    let s = ''
    
    for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{CustomTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999X'
  endif

    return s
endfunction

set tabline=%!GlobalTabLine()

" Netrw config 

" Detect if netrw was opened, if yes reopen it entering new tab
""autocmd BufEnter * execute 'Lexplore'

" Variable to track if netrw is open globally
" let g:netrw_opened = 0

" Function to open netrw globally in all windows
""function! OpenNetrwGlobally()
""    " Only open if netrw is not already open globally
""    if !g:netrw_opened
""        " Open netrw in the current window
""        Lexplore
""        let g:netrw_opened = 1
""    endif
""endfunction
""
" Function to close netrw globally in all windows
""function! CloseNetrwGlobally()
""    " Only close if netrw is open globally
""    if g:netrw_opened
""        " Close all netrw windows
""        bufdo if &filetype == 'netrw' | quit | endif
""        let g:netrw_opened = 0
""    endif
""endfunction
""
" Automatically open netrw in all windows if opened in any tab
""autocmd BufEnter * if &filetype == 'netrw' && g:netrw_opened == 0 | call OpenNetrwGlobally() | endif
""
" Automatically close netrw in all windows if it's closed in any tab
""autocmd BufLeave * if &filetype == 'netrw' | call CloseNetrwGlobally() | endif


let g:netrw_winsize     = 18
let g:netrw_linestyle   = 3
let g:netrw_banner      = 0
let g:netrw_browse_split= 3
let g:netrw_fastbrowse  = 3
let g:netrw_clipboard   = 0
let g:netrw_liststyle   = 3

" Hide dotfiles
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_hide = 1  
