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
if !has('nvim')
  set ttymouse=sgr
endif

"Commnad line
set showcmd
set showmode
set ruler

"Editing text
set completeopt-=longest
set completeopt+=noselect
set autocomplete
set complete+=o
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
set autoread

"Diagnostics
lua vim.diagnostic.config({ virtual_lines = { current_line = true } })


"------------------------------------------------------------------------------
"--GUI Options
"------------------------------------------------------------------------------

"Font
set guifont=MesloLGS\ Nerd\ Font:h12

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
nmap <Leader>q :lua require('mini.bufremove').delete()<CR>
nmap <Leader>hp :Gitsigns preview_hunk<CR>

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

"Signature help
lua require('lsp_signature').setup()

"Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_theme="maddn_airline"
let g:airline_powerline_fonts = 1
let g:tmuxline_preset = 'full'

"Count diagnostics from both language servers and nvim-lint.
function! AirlineDiagnostics(severity)
  let diagnostics = v:lua.vim.diagnostic.get(0, {'severity': a:severity})
  return empty(diagnostics) ? '' : a:severity[0] . ':' . len(diagnostics) .
        \ '(L' . (diagnostics[0].lnum + 1) . ')'
endfunction

let g:airline_section_error = '%{AirlineDiagnostics("Error")}'
let g:airline_section_warning = '%{join(filter([' .
      \ 'AirlineDiagnostics("Warn"), airline#extensions#whitespace#check()], ' .
      \ '"!empty(v:val)"), " ")}'
let g:airline_section_z = '%p%% %l:%c'


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

"Run 'pyang --format tree' on input file(s) and output in new split
function! s:PyangTree(files)
  let mkpath = s:SetMkfile()
  let paths = systemlist('make --no-print-directory --silent -C ' . mkpath .
        \ ' -f Makefile -f - vim-yangpath',
        \ ".PHONY: vim-yangpath\n" .
        \ "vim-yangpath:\n" .
        \ "\t@printf '%s\\n' $(abspath $(YANGPATH))\n")
  if v:shell_error
    echoerr join(paths, "\n")
    return
  endif
  let yangpath = $NCS_DIR . '/src/ncs/yang:' . join(paths, ':')
  vnew
  silent execute 'read !~/.local/bin/pyang --format tree --path ' . shellescape(yangpath) . ' ' . a:files
  1
endfunction

"Run PyangTree on current file and all files in PWD that augment it
function! s:PyangTreeWithAugments()
  let prefix = matchlist(getline(search('prefix', 'n')),
                       \ '^\s*prefix\s*\"\=\([^\"]*\)\"\=;\s*$')
  echo prefix[1]
  if len(prefix) > 1
    let files = system("grep -l 'augment.*" . prefix[1] . "' *.yang")
    call s:PyangTree(substitute(files, "\n", " ", "g") . expand('%'))
  endif
endfunction

command! PyangTree call s:PyangTree(expand('%'))
command! PyangTreeWithAugments call s:PyangTreeWithAugments()


"------------------------------------------------------------------------------
"--Auto commands
"------------------------------------------------------------------------------

augroup general
  autocmd!

  "Reload externally edited files.
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * checktime

  "Automatically open the quickfix window on :make
  autocmd QuickFixCmdPost [^l]* nested belowright cwindow
  autocmd QuickFixCmdPost l* nested belowright lwindow

  "Display NERDTree if Vim is being opened without a file
  if bufname('%') == ''
    autocmd VimEnter * NERDTree | ReadBookmarks
  endif

  "Keep help on the right
  autocmd BufEnter *.txt
        \ if &ft ==# 'help' |
        \   wincmd L |
        \ endif
augroup end


augroup filetypes
  autocmd!

  "PL/SQL
  autocmd FileType sql,plsql
        \ setlocal tabstop=3 |
        \ setlocal shiftwidth=3

  "Mail
  autocmd FileType mail
        \ setlocal colorcolumn=0 |
        \ setlocal linebreak |
        \ setlocal nolist |
        \ setlocal spell spelllang=en_gb |
        \ setlocal textwidth=0 |
        \ setlocal wrap

  "Java Make errorformat output as Ant
  autocmd FileType java
        \ set errorformat=\ %#[javac]\ %#%f:%l:%c:%*\\d:%*\\d:\ %t%[%^:]%#:%m,\%A\ %#[javac]\ %f:%l:\ %m,%-Z\ %#[javac]\ %p^,%-C%.%# |

  "Markdown filetypes
  autocmd FileType markdown
        \ setlocal autoindent |
        \ setlocal formatoptions-=l |
        \ setlocal spell spelllang=en_gb |
        \ setlocal textwidth=79

  "Text files with spelling
  autocmd Filetype text
        \ setlocal colorcolumn=0 |
        \ setlocal linebreak |
        \ setlocal spell spelllang=en_gb |
        \ setlocal nospell |
        \ setlocal wrap

  "XML files
  autocmd Filetype xml
        \ setlocal indentexpr= 
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
  autocmd WinEnter *
        \ if !exists('w:TrailingSpaceMatch') |
        \   let w:TrailingSpaceMatch=matchadd('TrailingSpace', '\s\+$') |
        \   call s:SetupWindow() |
        \  endif
  autocmd BufWinEnter * call s:SetupWindow()
augroup end


"Start tree-sitter highlighting for certain filetypes.
lua << EOF
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('treesitter_highlighting', { clear = true }),
    pattern = { 'javascript', 'javascriptreact', 'python', 'yang' },
    callback = function(ev)
      vim.treesitter.start(ev.buf)
    end
  })
EOF


"Auto lint files on save and open.
lua << EOF
  require('lint').linters_by_ft = {
    python = {'pylint'}, sh = {'shellcheck'}, fish = {'fish'}
  }

  vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
    group = vim.api.nvim_create_augroup('lint', { clear = true }),
    callback = function()
      require('lint').try_lint()
    end
  })
EOF


"Preserve symlink paths so LSP files stay in the consuming project.
lua << EOF
  local original_uri = require('vim.uri').uri_from_bufnr
  local symlink_paths = vim.api.nvim_create_augroup('lsp_symlink_paths', { clear = true })

  vim.api.nvim_create_autocmd({ 'BufAdd', 'BufFilePost' }, {
    group = symlink_paths,
    callback = function(ev)
      local name = vim.fn.bufname(ev.buf)
      if name ~= '' then
        vim.b[ev.buf].lsp_original_path = vim.fn.fnamemodify(name, ':p')
      end
    end
  })

  vim.uri_from_bufnr = function(bufnr)
    bufnr = bufnr == 0 and vim.api.nvim_get_current_buf() or bufnr
    local path = vim.b[bufnr].lsp_original_path
    if path and vim.bo[bufnr].buftype == '' then
      return vim.uri_from_fname(path)
    end
    return original_uri(bufnr)
  end
EOF


"------------------------------------------------------------------------------
"--Language servers
"------------------------------------------------------------------------------

lua << EOF
  vim.lsp.config('yang_lsp', {
    root_markers = { 'Makefile', '.git' }
  })

  vim.lsp.config('lemminx', {
    settings = { xml = { validation = { noGrammar = 'ignore' } } }
  })

  vim.lsp.config('make_ls', {
    cmd = { 'make-ls' },
    filetypes = { 'make' },
    root_markers = { 'Makefile', '.git' }
  })

  vim.lsp.config('tsc', {
    -- Use root_dir function to preserve symlink paths.
    root_dir = function(bufnr, on_dir)
      local path = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))
      local root = vim.fs.root(path, {
        'tsconfig.json',
        'jsconfig.json',
        'package.json',
        '.git'
      })

      -- Support standalone files by falling back to the current directory.
      on_dir(root or vim.fn.getcwd())
    end
  })

  vim.lsp.config('eslint', {
    -- Use root_dir function to preserve symlink paths.
    root_dir = function(bufnr, on_dir)
      local path = vim.uri_to_fname(vim.uri_from_bufnr(bufnr))
      local root = vim.fs.root(path, {
        'eslint.config.mjs',
        'eslint.config.js',
        'eslint.config.cjs',
        'package.json',
        '.git'
      })

      -- Start ESLint only when a project root is found.
      if root then
        on_dir(root)
      end
    end
  })

  vim.lsp.enable({
    'pyright', 'tsc', 'eslint', 'cssls', 'jsonls',
    'yang_lsp', 'lemminx', 'yamlls', 'make_ls',
  })
EOF
