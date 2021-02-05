if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "maddn"

let s:Black =       [ 0,  '#000000' ]
let s:DarkRed =     [ 1,  '#805959' ]
let s:DarkGreen =   [ 2,  '#598059' ]
let s:DarkYellow =  [ 3,  '#807359' ]
let s:DarkBlue =    [ 4,  '#596D80' ]
let s:DarkMagenta = [ 5,  '#735980' ]
let s:DarkCyan =    [ 6,  '#598079' ]
let s:Grey =        [ 7,  '#999999' ]

let s:DarkGrey =    [ 8,  '#333333' ]
let s:Red =         [ 9,  '#994D4D' ]
let s:Green =       [ 10, '#6B996B' ]
let s:Yellow =      [ 11, '#998A6B' ]
let s:Blue =        [ 12, '#6B8299' ]
let s:Magenta =     [ 13, '#896A99' ]
let s:Cyan =        [ 14, '#6B9991' ]
let s:White =       [ 15, '#B3B3B3' ]

let s:None =        'none'


function! s:Highlight(group, colorfg, ...)
  execute 'highlight clear ' . a:group
  let highlight_command = 'highlight! ' . a:group
  if len(a:colorfg) == 2
    let highlight_command .= ' ctermfg=' . a:colorfg[0] .
                          \  ' guifg=' . a:colorfg[1]
  endif
  if a:0 > 0 && len(a:1) == 2
    let highlight_command .= ' ctermbg=' . a:1[0] . ' guibg=' . a:1[1]
  endif
  if a:0 == 2
    let highlight_command .= ' cterm=' . a:2 . ' gui=' . a:2
  endif
  execute highlight_command
endfunction

function! s:HighlightLink(from, to)
  execute 'highlight clear ' . a:from
  execute 'highlight link ' . a:from . ' ' . a:to
endfunction


call s:Highlight('Normal',            s:White                         )
call s:Highlight('Comment',           s:Cyan                          )
call s:Highlight('Constant',          s:DarkRed                       )
call s:Highlight('String',            s:Yellow                        )
call s:Highlight('Identifier',        s:Green                         )
call s:Highlight('Statement',         s:Blue                          )
call s:Highlight('Operator',          s:DarkRed                       )
call s:Highlight('PreProc',           s:Magenta                       )
call s:Highlight('Type',              s:Green                         )
call s:Highlight('Special',           s:DarkRed                       )
call s:Highlight('Ignore',            s:Red                           )
call s:Highlight('Underlined',        s:Red                           )
call s:Highlight('Error',             s:DarkRed                       )
call s:Highlight('Todo',              s:DarkYellow                    )

call s:Highlight('Directory',         s:Blue                          )

call s:Highlight('StatusLine',        s:Yellow,       s:DarkGrey      )
call s:Highlight('StatusLineNC',      s:Grey,         s:DarkGrey      )
call s:Highlight('QuickFixLine',      s:Grey,         s:DarkGrey      )

call s:Highlight('VertSplit',         s:Grey,         []              )
call s:Highlight('ColorColumn',       s:Black,        s:DarkRed       )
call s:Highlight('LineNr',            s:DarkGrey                      )

call s:Highlight('Visual',            [],             s:DarkGrey      )
call s:Highlight('CursorColumn',      [],             s:Black,        )
call s:Highlight('CursorLine',        [],             s:Black,        )
call s:Highlight('CursorLineNr',      s:Yellow,       s:Black         )

call s:Highlight('DiffAdd',           s:White,        s:DarkGreen     )
call s:Highlight('DiffDelete',        s:Grey,         s:DarkRed       )
call s:Highlight('DiffChange',        s:DarkGrey,     s:DarkBlue      )
call s:Highlight('DiffText',          s:White,        s:DarkBlue      )

call s:Highlight('Search',            s:DarkGrey,     s:Yellow        )
call s:Highlight('WildMenu',          s:DarkGrey,     s:DarkYellow    )

call s:Highlight('GitGutterAdd',      s:Green                         )
call s:Highlight('GitGutterChange',   s:Yellow                        )
call s:Highlight('GitGutterDelete',   s:Red                           )

call s:Highlight('Tabs',              [],             s:DarkGrey      )
call s:Highlight('SubtleSpaces',      [],             s:Black         )
call s:Highlight('MixedSpaces',       [],             s:DarkGrey      )
call s:Highlight('TrailingSpace',     [],             s:DarkCyan      )

call s:Highlight('xmlTag',            s:Blue                          )
call s:Highlight('xmlTagName',        s:Blue                          )
call s:Highlight('xmlEndTag',         s:Blue                          )


call s:HighlightLink('ErrorMsg',         'Error'          )
call s:HighlightLink('WarningMsg',       'Todo'           )

call s:HighlightLink('SpellBad',        'DiffDelete'      )
call s:HighlightLink('SpellCap',        'WildMenu'        )
call s:HighlightLink('SpellRare',       'WileMenu'        )
call s:HighlightLink('SpellLocal',      'WildMenu'        )

call s:HighlightLink('Pmenu',           'StatusLine'      )
call s:HighlightLink('PmenuSel',        'WildMenu'        )
call s:HighlightLink('PmenuSbar',       'StatusLineNC'    )
call s:HighlightLink('PmenuThumb',      'StatusLine'      )

call s:HighlightLink('MoreMsg',         'Todo'            )
call s:HighlightLink('Question',        'MoreMsg'         )
call s:HighlightLink('ModeMsg',         'Comment'         )
call s:HighlightLink('Title',           'Identifier'      )

call s:HighlightLink('Folded',          'StatusLine'      )
call s:HighlightLink('FoldColumn',      'LineNr'          )
call s:HighlightLink('SignColumn',      'LineNr'      )

call s:HighlightLink('Conceal',         'StatusLine'      )
call s:HighlightLink('SpecialKey',      'Todo'            )
call s:HighlightLink('NonText',         'LineNr'          )
call s:HighlightLink('MatchParen',      'DiffText'        )

call s:HighlightLink('TabLine',         'StatusLine'      )
call s:HighlightLink('TabLineSel',      'WildMenu'        )
call s:HighlightLink('TabLineFill',     'StatusLineNC'    )
