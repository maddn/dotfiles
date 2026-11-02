let g:tmuxline_preset = {
      \ 'a': '#S',
      \ 'b': '#F',
      \ 'c': '#W',
      \ 'win': ['#I', '#W'],
      \ 'cwin': ['#I', '#W'],
      \ 'x': ['%a', '%b %d'],
      \ 'y': '%R',
      \ 'z': '#H',
      \ 'win_options': {'window-status-bell-style': 'none,fg=colour0,bg=colour1'},
      \ }

function! GenerateTmuxline()
  set termguicolors
  packadd vim-airline
  packadd tmuxline.vim
  source generated/maddn.vim

  let theme = tmuxline#api#create_theme_from_airline(g:airline#themes#maddn#palette.normal)
  let line = tmuxline#load_line(g:tmuxline_preset)
  let settings = tmuxline#get_line_settings(line, theme, tmuxline#get_separators())
  call writefile(['# Generated from theme/generated/maddn.vim and theme/tmuxline.vim.', ''] + settings, 'generated/tmuxline.conf')
endfunction
