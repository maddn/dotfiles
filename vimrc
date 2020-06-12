execute pathogen#infect()

set nocompatible
set shell=/bin/bash

"------------------------------------------------------------------------------
"--Comands
"------------------------------------------------------------------------------
filetype plugin on
syntax enable
colorscheme maddn


"------------------------------------------------------------------------------
"--Options
"------------------------------------------------------------------------------

"Moving around, searching and patterns
"-------------------------------------
set autochdir
set ignorecase
set smartcase

"Displaying text
"---------------
set nowrap
set fillchars=vert:\│
set number

"Syntax, highlighting and spelling
"---------------------------------
set background=dark
set hlsearch
set cursorline
set colorcolumn=80

"Multiple windows
"----------------
set laststatus=2
set noequalalways
set splitright

"Mouse
"-----
set mouse=a
set ttym=urxvt  "Allow mouse > 252 columns

"Messages and info
"-----------------
set showcmd
set showmode
set ruler

"Editing text
"------------
set completeopt+=longest
set showmatch
set nojoinspaces

"Tabs and identing
"-----------------
set tabstop=2
set shiftwidth=2
set expandtab

"Disable bell
"------------
set visualbell t_vb=

"Files
"-----
set viminfo+=n~/.vim/viminfo


"------------------------------------------------------------------------------
"--GUI Options
"------------------------------------------------------------------------------

"Font
"----
set guifont=Menlo:h12

"Bars
"----
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

"Use system clipboard
"--------------------
set clipboard=unnamed

"Transparency
"------------
if has("gui_running")
    set transparency=7
endif


"------------------------------------------------------------------------------
"--Status line
"------------------------------------------------------------------------------

"Set the left side of the status line
"------------------------------------
set statusline=\ [Buf:\ %n]                                     "Buffer number
set statusline+=\ %F%<                                          "File name and path
set statusline+=\ [%{empty(&filetype)?'':&filetype.'\ \|\ '}    "File type
set statusline+=\%{empty(&fileformat)?'':&fileformat.':'}       "File format
set statusline+=%{&fenc!=''?&fenc:&enc}]                        "File encoding
set statusline+=\ [%{&l:expandtab?'Spaces':'Tabs'}]             "Tabs / Spaces
set statusline+=\ %h%w%m%r                                      "Help / Preview / Modified / Readonly
set statusline+=\%{fugitive#statusline()}                       "Fugutive plugin

"Set the right side of the status line
"-------------------------------------
set statusline+=%=\ %#warningmsg#                               "Synastic plugin
set statusline+=%{SyntasticStatuslineFlag()}                    "Syntasic plugin
set statusline+=%*                                              "Syntasic plugin
set statusline+=\ %=[0x%B]\ [Line:\ %l/%L\ \|\ Col:\ %c%V]\ (%P)


"------------------------------------------------------------------------------
"--Useful key (re)mappings
"------------------------------------------------------------------------------

"Move up/down virtual lines
nnoremap <buffer> <silent> k gk
nnoremap <buffer> <silent> j gj

"Clear current search highlight
nmap <Leader>cs :let @/ = ""<CR>

"Easy Save As...
nmap <leader>sav :sav <C-R>=expand('%:p')<CR>

"save as root with w!!
cmap w!! w !sudo tee % > /dev/null

"Copy path/filename to clipboard
nmap <Leader>cn :let @*=expand("%")<CR>
nmap <Leader>cl :let @*=expand("%:p")<CR>

"Cycle through buffers
map <C-h> :bprevious<CR>
map <C-l> :bnext<CR>

"Esc key
inoremap jj <esc>
inoremap jk <esc>

"Quit all on ZZ
nmap ZZ :qa<CR>

"Move through display lines
nnoremap j gj
nnoremap k gk


"------------------------------------------------------------------------------
"--Plugins
"------------------------------------------------------------------------------

"NERDTree options
"----------------
nmap <Leader>nt :NERDTreeToggle<CR>
let g:NERDTreeShowBookmarks=1

"Tagbar options
"--------------
nmap <Leader>fl :TagbarToggle<CR>

"Bbye options
"-----------------------
nnoremap <Leader>q :Bdelete<CR>

"Vorax options
"-------------
let g:vorax_output_abort_key='F12'
let g:vorax_folding_enable=0

"Display NERDTree and Taglist if Vim is being opened without a file
"------------------------------------------------------------------
if bufname('%') == ''
    "Open NERDTree, read bookmarks, move to main window
    autocmd VimEnter * NERDTree | ReadBookmarks
    autocmd VimEnter * wincmd p

    "Open TagList
    "autocmd VimEnter * TlistToggle | exe bufwinnr('__Tag_List__') . 'wincmd w' | setlocal statusline=%f | wincmd p
    "autocmd VimEnter * TagbarToggle
endif

"Synastic options
"----------------

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_java_javac_config_file_enabled = 1
let g:syntastic_java_checkers = ["javac"]
let g:syntastic_javascript_eslint_generic=1
let g:syntastic_javascript_eslint_exe="eval (npm bin)/eslint"
let g:syntastic_javascript_eslint_exec="/bin/ls"
let g:syntastic_javascript_eslint_args='-f compact'
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_closurecompiler_script = "closure-compiler"
let g:syntastic_python_checkers = ["pylint"]
let g:syntastic_yang_pyang_exe = "/usr/local/bin/pyang"
let g:syntastic_yang_pyang_args = "--path=$NCS_DIR/src/ncs/yang --canonical"

"JSX
"---
let g:jsx_ext_required = 0

"Airline
"-------
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme="maddn"

"YouCompleteMe
"-------------
nnoremap <leader>jd :YcmCompleter GoTo<CR>
let g:ycm_always_populate_location_list = 0


"------------------------------------------------------------------------------
"--Auto commands
"------------------------------------------------------------------------------

"Automatically open the quickfix window on :make (using the full width)
"----------------------------------------------------------------------
autocmd QuickFixCmdPost [^l]* nested botright cwindow
autocmd QuickFixCmdPost l* nested botright lwindow

"Set PL/SQL filetypes
"--------------------
autocmd BufNewFile,BufRead *.pkh,*.pkb,*.pls,*.pks set filetype=sql | SQLSetType plsqlvorax
autocmd BufNewFile,BufRead *.ddl,*.sqlpart,*.sql,*.grt set filetype=sql | SQLSetType sqlvorax

"PL/SQL options
"--------------
autocmd FileType sql,plsql
\   setlocal tabstop=3 |
\   setlocal shiftwidth=3 |
\   setlocal expandtab

"Mail options
"------------
autocmd FileType mail
\   setlocal tw=0 |
\   setlocal wrap |
\   setlocal linebreak |
\   setlocal nolist |
\   setlocal colorcolumn=0 |
\   setlocal spell

"XML auto reformat using xmllint
"-------------------------------
"autocmd FileType xml exe ":silent 1,$!xmllint --format --recover - 2>/dev/null"

"Maven filetypes
"---------------
autocmd FileType pom compiler mvn

"Java Make errorformat output as Ant
"-----------------------------------
autocmd FileType java set errorformat=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%#

"Markdown filetypes
"------------------
autocmd FileType markdown
\   setlocal textwidth=79 |
\   setlocal formatoptions-=l |
\   setlocal spell spelllang=en_gb |
\   setlocal autoindent

"Large files
"-----------
autocmd BufReadPre * if getfsize(expand("<afile>")) > 1024*1024 | let b:syntastic_mode="passive" | endif


"------------------------------------------------------------------------------
"--Whitespace highlighting
"------------------------------------------------------------------------------

"Higlight groups
"---------------
if has("gui_running")
    highlight Tabs guibg=#333333
    highlight SubtleSpaces guibg=#000000
    highlight MixedSpaces guibg=#333333
    highlight TrailingSpace guibg=#598079
else
    highlight Tabs ctermbg=DarkGrey
    highlight SubtleSpaces ctermbg=Black
    highlight MixedSpaces ctermbg=DarkGrey
    highlight TrailingSpace ctermbg=DarkCyan
endif

"Helper fucntions
"----------------
function! UnHighlightSpaces()
    if exists('w:MixedSpaceMatch')
        call matchdelete(w:MixedSpaceMatch)
        unlet w:MixedSpaceMatch
    endif
    if exists('w:SubtleSpaceMatch')
        call matchdelete(w:SubtleSpaceMatch)
        unlet w:SubtleSpaceMatch
    endif
endfunction

function! UnHighlightTabs()
    if exists('w:TabMatch')
        call matchdelete(w:TabMatch)
        unlet w:TabMatch
    endif
endfunction

function! HighlightSpaces()
    call UnHighlightTabs()
    if !exists('w:MixedSpaceMatch')
        let w:MixedSpaceMatch=matchadd('MixedSpaces', '^ \{2,}\|\t\zs \+\| \+\ze\t')
    endif
    if !exists('w:SubtleSpaceMatch')
        let w:SubtleSpaceMatch=matchadd('SubtleSpaces', '\.\@<! \{2,}', 1)
    endif
endfunction

function! HighlightTabs()
    call UnHighlightSpaces()
    if !exists('w:TabMatch')
        let w:TabMatch=matchadd('Tabs', '\t')
    endif
endfunction

function! SetupWindow()
    if (bufname('%') != 'NERD_tree_1') && (bufname('%') != '__Tag_List__')
        if &l:expandtab
            call HighlightTabs()
        else
            call HighlightSpaces()
        endif
    else
        call UnHighlightTabs()
        call UnHighlightSpaces()
    endif
    if (bufname('%') == '__Tag_List__')
        setlocal statusline=%f
    endif
endfunction

"Commands
"--------
command! Spaces setlocal expandtab | call HighlightTabs()
command! Tabs setlocal noexpandtab | call HighlightSpaces()

"Trailing space highlighting (only when not in Insert mode)
"----------------------------------------------------------
let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$')
autocmd InsertEnter * call matchdelete(w:TrailingSpaceMatch) | let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+\%#\@<!$')
autocmd InsertLeave * call matchdelete(w:TrailingSpaceMatch) | let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$')

"Ensure highlighting is applied to new windows
"---------------------------------------------
call SetupWindow()
autocmd VimEnter * autocmd WinEnter * let w:created=1
autocmd VimEnter * let w:created=1
autocmd WinEnter * if !exists('w:created') | let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$') | call SetupWindow() | endif
autocmd BufWinEnter * call SetupWindow()


"------------------------------------------------------------------------------
"--Useful functions
"------------------------------------------------------------------------------

"Zoom / Restore window.
"----------------------
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <C-A> :ZoomToggle<CR>

"Make with Makefile in a parent directory
"----------------------------------------
function! SetMkfile()
  let filemk = "Makefile"
  let pathmk = "./"
  let depth = 1
  while depth < 8
    if filereadable(pathmk . filemk)
      return pathmk
    endif
    let depth += 1
    let pathmk = "../" . pathmk
  endwhile
  return "."
endf
command! -nargs=* Make let $mkpath = SetMkfile() | make <args> -C $mkpath

