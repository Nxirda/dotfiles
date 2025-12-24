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

set wrap
set showmatch

set autoindent
set smartindent

set mouse=a

set number
set cursorline 
set nocursorcolumn
set colorcolumn=100
set termguicolors

" TAB autocompletion menue
set wildmenu
set wildoptions=fuzzy
set wildmode=list:longest
set wildignore=*.docx "insert more files to ignore"

" Command line area
set noshowmode
set showcmd
set shortmess+=F

" Automatic parenthesis closing
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
inoremap " ""<Left>
inoremap ' ''<Left>

" Enable file type detection
filetype on
filetype indent on
filetype plugin on
colorscheme mocha 

" Simple function to have a nvim like mode display
function! FullName()
    return   mode() ==# 'n' ? 'NORMAL'      : 
            \mode() ==# 'i' ? 'INSERT'      :
            \mode() ==# 'v' ? 'VISUAL'      :
            \mode() ==# 'R' ? 'REPLACE'     :
            \mode() ==# 'c' ? 'COMMAND LINE':
            \mode() ==# 't' ? 'TERMINAL'    : ''
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

let g:right_circle = "\ue0b4"
let g:left_circle  = "\ue0b6"

let g:right_trianle = "\ue0b0"
let g:left_triangle = "\ue0b2"

let g:low_right_slant = "\ue0ba"
let g:high_right_slant = "\ue0be"
let g:low_left_slant = "\ue0b8"
let g:high_left_slant = "\ue0bc"

function! ActiveStatusLine()
    let statusline = ''
    " Mode part
    let statusline .= '%#ModeBg# %{FullName()}'
    let statusline .= '%#InverseMode#%{g:right_circle}'
    " File info
    let statusline .= '%#FileInfosBg# %f %M %Y %R'
    let statusline .= '%#InverseFile#%{g:right_circle}'
    " File format and encoding
    let statusline .= '%#Transparent# %{&fileformat} [%{&fileencoding}]'
    " Separator
    let statusline .= '%='
    " Current char info
    let statusline .= 'ascii: %b hex: 0x%B '
    " Col/line info
    let statusline .= '%#InversePlace#%{g:left_circle}%#PlaceInfo#col:%c line:%l/%L '
    let statusline .= '%#InversePercent#%{g:left_circle}'
    let statusline .= '%#Percent#[%p]%% %#NONE#'
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

        if i+1 < tabpagenr('$')
            let s .= g:high_left_slant
        endif
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

" Search popup in current dir
function! SetupSearchBar(str, width, length, reference)
    let counter = printf('%d/%d', a:length, a:reference)
    let counter_width = strwidth(counter)
    " Ensure there's space for at least one character from str
    let available_width = max([a:width - counter_width - 2, 1]) " -2 for spacing
    " Truncate str if necessary
    let truncated_str = strcharpart(a:str, 0, available_width)
    " Build the final formatted string
    return printf('%-*s %s', available_width, truncated_str, counter)
endfunction

function! SearchPopup()
    let g:search_height  = float2nr(&lines/2)
    let g:search_width   = float2nr(&columns/2) 
    let row     = float2nr((&lines - g:search_height)/2)
    let col     = float2nr((&columns - g:search_width)/2)
    
    let g:visible_lines = (row * 2) -2
    let g:fuzzy_query = ''
    let g:cursor = '█'
    let g:splitter = repeat('─', g:search_width)
    " Read the whole files once then copy/map it in tem variables
    let g:curr_files = split(glob('**/*', 1), "\n")
    
    let g:nb_files = len(g:curr_files)
    
    let g:search_bar = SetupSearchBar(g:fuzzy_query . g:cursor, g:search_width, g:nb_files, g:nb_files)

    let g:files = copy(g:curr_files)
    let g:selected_index = 0

    let files_slice = map(copy(g:files), 'v:key == g:selected_index ? "> " . v:val : "  " . v:val')
    let popup_content = [g:search_bar, g:splitter] + files_slice

    let opts = {
                \ 'line': row,
                \ 'col': col,
                \ 'minwidth': g:search_width,
                \ 'maxwidth' : g:search_width,
                \ 'minheight': g:search_height,
                \ 'maxheight' : g:search_height,
                \ 'border': [],
                \ 'filter': 'InputFilter',
                \ 'mapping': v:false,
                \ 'scrollbar' : 0,
                \ 'highlight' : 'Normal'
                \ }
    let g:fuzzy_popup_id = popup_create(popup_content, opts)
    call popup_setoptions(g:fuzzy_popup_id, {'borderchars': [ '─', '│', '─', '│', '┌', '┐', '┘', '└']})
endfunction

function! InputFilter(id, key)
    "close popup if escape"
    if a:key == "\<Esc>"
        call popup_close(a:id)
        return 1
    
    elseif a:key == "\<CR>"
        execute 'tabnew ' . g:files[g:selected_index]
        call popup_close(a:id) 
        return 1
    
    elseif a:key == "\<Tab>"            " && g:selected_index < len(g:files) -1  Tab goes down
        if g:selected_index < len(g:files) -1
            let g:selected_index += 1
        endif

    elseif a:key == "\<S-Tab>"  "&& g:selected_index > 0          Maj tab goes up
        if g:selected_index > 0
            let g:selected_index -= 1
        endif
    
    elseif a:key == "\<BS>" || a:key == "\<C-H>"                "Handles backspace
        if strlen(g:fuzzy_query) > 0
            let g:fuzzy_query = strpart(g:fuzzy_query, 0, strlen(g:fuzzy_query) -1)
        endif
        " Reset the g:files variables that only olds chunks when going forward
        " for better efficiency
        let g:files = filter(copy(g:curr_files), 'v:val =~ g:fuzzy_query')
    
    elseif a:key =~# '.'
        let g:fuzzy_query .= a:key
    endif
    
    " Filter current selection with new query 
    let g:files = filter(g:files, 'v:val =~ g:fuzzy_query')
    let g:selected_index = min([g:selected_index, len(g:files) - 1])
    
    " Files slice
    let start_index = floor(g:selected_index / g:visible_lines) * g:visible_lines
    let start_index = float2nr(start_index)
    let end_index = min([start_index + g:visible_lines -1, len(g:files) -1])
    
    let files_slice = g:files[start_index:end_index] 
    let relative_index = g:selected_index - start_index
    
    " Needs re write but does the trick atm
    let files_slice = map(copy(files_slice), 'v:key == relative_index ? "> " . v:val : "  " . v:val')
    let files_slice = map(copy(files_slice), 'len(v:val) > g:search_width ? strpart(v:val, 0,g:search_width - 3) . "..." : v:val')
   
    let curr_matches = len(g:files)
    let g:search_bar = SetupSearchBar(g:fuzzy_query . g:cursor, g:search_width, curr_matches, g:nb_files)

    let popup_content = [g:search_bar, g:splitter] + files_slice
    call popup_settext(a:id, popup_content)

    return 1
endfunction

command! SearchPopup call SearchPopup()
nnoremap <Esc><Space> :call SearchPopup()<CR>
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

" Hide dotfiles : gh to show hidden files
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_hide = 1  

" OCaml related stuff : ocp-indent
set rtp^="/home/Nxirda/.opam/cs3110-install/share/ocp-indent/vim"
