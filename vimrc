try
  execute pathogen#infect()
catch
endtry

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

"Set PWD
set autochdir

"Display
set background=dark
set colorcolumn=80
set cursorline
set fillchars=vert:\│
set nowrap
set number

"Windows
set laststatus=2
set noequalalways
set splitright

"Mouse
set mouse=a
set ttymouse=sgr

"Commnad line
set showcmd
set showmode
set ruler

"Editing text
set completeopt+=longest
set showmatch
set nojoinspaces

"Searching
set hlsearch
set ignorecase
set smartcase

"Tabs and identing
set expandtab
set tabstop=2
set shiftwidth=2

"Disable bell
set visualbell t_vb=

"Files
set viminfo+=n~/.vim/viminfo


"------------------------------------------------------------------------------
"--GUI Options
"------------------------------------------------------------------------------

"Font
set guifont=Menlo:h12

"Bars
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

"Use system clipboard
set clipboard=unnamed

"Transparency
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
"--Key mappings
"------------------------------------------------------------------------------

"Move up/down virtual lines
nnoremap <buffer> <silent> k gk
nnoremap <buffer> <silent> j gj

"Move through display lines
nnoremap j gj
nnoremap k gk

"Esc key
inoremap jj <esc>
inoremap jk <esc>

"Clear current search highlight
nmap <Leader>cs :let @/ = ""<CR>

"Easy Save As...
nmap <leader>sav :sav <C-R>=expand('%:p')<CR>

"Copy path/filename to clipboard
nmap <Leader>cn :let @"=expand("%")<CR>
nmap <Leader>cl :let @"=expand("%:p")<CR>

"Cycle through buffers
nmap <Leader>, :bprevious<CR>
nmap <Leader>. :bnext<CR>

"Quit all on ZZ
nmap ZZ :qa<CR>

"Plugin shortcuts
nmap <Leader>nt :NERDTreeToggle<CR>
nmap <Leader>q :Bdelete<CR>

"Zoom window
nmap <Leader>a :ZoomToggle<CR>

"save as root with w!!
cmap w!! w !sudo tee % > /dev/null

"XML reformat using xmllint
cmap xmllint :silent 1,$!xmllint --format --recover - 2>/dev/null


"------------------------------------------------------------------------------
"--Plugins
"------------------------------------------------------------------------------

"NERDTree
let g:NERDTreeShowBookmarks=1

"Synastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_java_checkers = ["javac"]
let g:syntastic_javascript_eslint_generic=1
let g:syntastic_javascript_eslint_exe="eval (npm bin)/eslint"
let g:syntastic_javascript_eslint_exec="/bin/ls"
let g:syntastic_javascript_eslint_args='-f compact'
let g:syntastic_javascript_checkers = ["eslint"]
let g:syntastic_javascript_closurecompiler_script = "closure-compiler"
let g:syntastic_python_checkers = ["pylint"]
let g:syntastic_yang_pyang_exe = "~/.local/bin/pyang"
let g:syntastic_yang_pyang_args =
  \ "--path=$NCS_DIR/src/ncs/yang --canonical --ignore-error=MODULE_NOT_FOUND"

"JSX
let g:jsx_ext_required = 0

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme="maddn_airline"
let g:airline_powerline_fonts = 1
let g:tmuxline_preset = 'full'


"------------------------------------------------------------------------------
"--Whitespace highlighting
"------------------------------------------------------------------------------

"Higlight groups
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


"------------------------------------------------------------------------------
"--Whitespace functions
"------------------------------------------------------------------------------

function! s:UnHighlightSpaces()
  if exists('w:MixedSpaceMatch')
    call matchdelete(w:MixedSpaceMatch)
    unlet w:MixedSpaceMatch
  endif
  if exists('w:SubtleSpaceMatch')
    call matchdelete(w:SubtleSpaceMatch)
    unlet w:SubtleSpaceMatch
  endif
endfunction

function! s:UnHighlightTabs()
  if exists('w:TabMatch')
    call matchdelete(w:TabMatch)
    unlet w:TabMatch
  endif
endfunction

function! s:HighlightSpaces()
  call s:UnHighlightTabs()
  if !exists('w:MixedSpaceMatch')
    let w:MixedSpaceMatch=matchadd('MixedSpaces', '^ \{2,}\|\t\zs \+\| \+\ze\t')
  endif
  if !exists('w:SubtleSpaceMatch')
    let w:SubtleSpaceMatch=matchadd('SubtleSpaces', '\.\@<! \{2,}', 1)
  endif
endfunction

function! s:HighlightTabs()
  call s:UnHighlightSpaces()
  if !exists('w:TabMatch')
    let w:TabMatch=matchadd('Tabs', '\t')
  endif
endfunction

function! s:SetupWindow()
    if (bufname('%') != 'NERD_tree_1')
        if &l:expandtab
            call s:HighlightTabs()
        else
            call s:HighlightSpaces()
        endif
    else
        call s:UnHighlightTabs()
        call s:UnHighlightSpaces()
    endif
endfunction

"Commands
command! Spaces setlocal expandtab | call s:HighlightTabs()
command! Tabs setlocal noexpandtab | call s:HighlightSpaces()


"------------------------------------------------------------------------------
"--Other useful functions
"------------------------------------------------------------------------------

" Set classpath to find jars in NSO package structure
function! s:SetJavaClasspath()
  if expand('%:e') == 'java'
    let javapath = "./"
    let depth = 1
    while depth < 12 && !empty(glob(javapath))
      if !empty(glob(javapath . '/src'))
        let g:syntastic_java_javac_classpath =
            \ $NCS_DIR . '/java/jar/*.jar:' .
            \ javapath . 'build/classes:' .
            \ javapath  . '../../private-jar/*.jar:' .
            \ javapath . '../../shared-jar/*.jar'
        return
      endif
      let depth += 1
      let javapath = "../" . javapath
    endwhile
  endif
endfunction

"Make with Makefile in a parent directory
function! s:SetMkfile()
  let filemk = "Makefile"
  let pathmk = "./"
  let depth = 1
  while depth < 12
    if filereadable(pathmk . filemk)
      return pathmk
    endif
    let depth += 1
    let pathmk = "../" . pathmk
  endwhile
  return "."
endfunction

command! -nargs=* Make let $mkpath = s:SetMkfile() | make <args> -C $mkpath

"Zoom / Restore window.
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


"------------------------------------------------------------------------------
"--Auto commands
"------------------------------------------------------------------------------

augroup general
  autocmd!

  "Automatically open the quickfix window on :make
  autocmd QuickFixCmdPost [^l]* nested belowright cwindow
  autocmd QuickFixCmdPost l* nested belowright lwindow

  "Large files
  autocmd BufReadPre *
        \ if getfsize(expand("<afile>")) > 1024*1024 |
        \   let b:syntastic_mode="passive" |
        \ endif

  "Copy to terminal
  autocmd TextYankPost *
        \ if v:event.operator is 'y' && v:event.regname is '' |
        \   if exists(':OSCYankReg') |
        \     OSCYankReg " |
        \   endif |
        \ endif

  "Display NERDTree if Vim is being opened without a file
  if bufname('%') == ''
    autocmd VimEnter * NERDTree | ReadBookmarks
  endif
augroup end


augroup filetypes
  autocmd!

  "Set PL/SQL filetypes
  autocmd BufNewFile,BufRead *.pkh,*.pkb,*.pls,*.pks
        \ set filetype=sql | SQLSetType plsqlvorax
  autocmd BufNewFile,BufRead *.ddl,*.sqlpart,*.sql,*.grt
        \ set filetype=sql | SQLSetType sqlvorax

  "PL/SQL options
  autocmd FileType sql,plsql
        \ setlocal tabstop=3 |
        \ setlocal shiftwidth=3

  "Mail options
  autocmd FileType mail
        \ setlocal tw=0 |
        \ setlocal wrap |
        \ setlocal linebreak |
        \ setlocal nolist |
        \ setlocal colorcolumn=0 |
        \ setlocal spell

  "Java Make errorformat output as Ant
  autocmd FileType java
        \ set errorformat=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%# |
        \ call s:SetJavaClasspath()

  "Markdown filetypes
  autocmd FileType markdown
        \ setlocal textwidth=79 |
        \ setlocal formatoptions-=l |
        \ setlocal spell spelllang=en_gb |
        \ setlocal autoindent
augroup end


augroup whitespace
  autocmd!

  "Trailing space highlighting (only when not in Insert mode)
  if !exists('w:TrailingSpaceMatch')
    let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$')
    call s:SetupWindow()
  endif

  autocmd InsertEnter *
        \ call matchdelete(w:TrailingSpaceMatch) |
        \ let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+\%#\@<!$')

  autocmd InsertLeave *
        \ call matchdelete(w:TrailingSpaceMatch) |
        \ let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$')

  "Ensure highlighting is applied to new windows
  autocmd VimEnter * autocmd WinEnter * let w:created=1
  autocmd VimEnter * let w:created=1
  autocmd WinEnter *
        \ if !exists('w:created') |
        \   let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$') |
        \   call s:SetupWindow() |
        \  endif
  autocmd BufWinEnter * call s:SetupWindow()
augroup end
