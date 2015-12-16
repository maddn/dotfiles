"File format based on solarized.vim
"
"Initialisation
"------------------------------------------------------------------------------
set t_Co=16
set t_md=
set background=dark

hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name = "madders"

"Colours
"------------------------------------------------------------------------------
"   Black          #000000
"   Dark Red       #805959
"   Dark Green     #598059
"   Dark Yellow    #807359
"   Dark Blue      #596D80
"   Dark Magenta   #735980
"   Dark Cyan      #598079
"   Grey           #999999

"   Dark Grey      #333333
"   Red            #994d4d
"   Green          #6b996b
"   Yellow         #998a6b
"   Blue           #6b8299
"   Magenta        #896a99
"   Cyan           #6b9991
"   White          #b3b3b3

"Basic highlighting
"------------------------------------------------------------------------------
"
"   Comment         any comment
"
"   Constant        any constant
"   Number          a number constant: 234, 0xff
"   Boolean         a boolean constant: TRUE, false
"   Float           a floating point constant: 2.3e10
"
"   String          a string constant: "this is a string"
"   Character       a character constant: 'c', '\n'
"
"   Identifier      any variable name
"   Function        function name (also: methods for classes)
"
"   Statement       any statement
"   Conditional     if, then, else, endif, switch, etc.
"   Repeat          for, do, while, etc.
"   Label           case, default, etc.
"   Keyword         any other keyword
"   Exception       try, catch, throw
"
"   Operator        "sizeof", "+", "*", etc.
"
"   PreProc         generic Preprocessor
"   Include         preprocessor #include
"   Define          preprocessor #define
"   Macro           same as Define
"   PreCondit       preprocessor #if, #else, #endif, etc.
"
"   Type            int, long, char, etc.
"   StorageClass    static, register, volatile, etc.
"   Structure       struct, union, enum, etc.
"   Typedef         A typedef
"
"   Special         any special symbol
"   SpecialChar     special character in a constant
"   Tag             you can use CTRL-] on this
"   Delimiter       character that needs attention
"   SpecialComment  special things inside a comment
"   Debug           debugging statements
"
"   Ignore          left blank, hidden  |hl-Ignore|
"
"   Error           any erroneous construct
"
"   Todo            anything that needs extra attention; mostly the
"                    keywords TODO FIXME and XXX

if has("gui_running")
    hi          Normal          guifg=#b3b3b3       guibg=#141414
    hi          Comment         guifg=#6b9991
    hi          Constant        guifg=#805959
    hi          String          guifg=#998a6b
    hi          Identifier      guifg=#6b996b
    hi          Statement       guifg=#6b8299
    hi          Operator        guifg=#805959
    hi          PreProc         guifg=#896a99
    hi          Type            guifg=#6b996b
    hi          Special         guifg=#805959
    hi          Ignore          guifg=#994d4d
    hi          Error           guifg=#994d4d       guibg=#000000       gui=underline
    hi          Todo            guifg=#807359       guibg=#000000       gui=underline

    hi          StatusLine      guifg=#998a6b       guibg=#333333       gui=none
    hi          StatusLineNC    guifg=#999999       guibg=#333333       gui=none
    hi          VertSplit       guifg=#999999       guibg=NONE          gui=none
    hi          LineNr          guifg=#333333
    hi          ColorColumn     guibg=#805959
    hi          Visual          guibg=#333333
    hi          Cursor          guibg=#998a6b
    hi          CursorLine      guibg=#000000       gui=none
    hi          CursorLineNr    guifg=#807359       guibg=#000000

    hi          DiffAdd         guifg=#b3b3b3       guibg=#807359
    hi          DiffChange      guifg=#333333       guibg=#596D80
    hi          DiffDelete      guifg=#999999       guibg=#805959
    hi          DiffText        guifg=#b3b3b3       guibg=#596D80

    hi          Directory       guifg=#6b8299
    hi          Search          guifg=#333333       guibg=#998a6b
    hi          Title           guifg=#896a99
else
    hi          Comment         ctermfg=Cyan
    hi          Constant        ctermfg=DarkRed
    hi          String          ctermfg=Yellow
    hi          Identifier      ctermfg=Green
    hi          Statement       ctermfg=Blue
    hi          Operator        ctermfg=DarkRed
    hi          PreProc         ctermfg=Magenta
    hi          Type            ctermfg=Green
    hi          Special         ctermfg=DarkRed
    hi          Ignore          ctermfg=Red
    hi          Error           ctermfg=Red         ctermbg=Black       cterm=Underline
    hi          Todo            ctermfg=Brown       ctermbg=Black       cterm=Underline

    hi          StatusLine      ctermfg=Yellow      ctermbg=DarkGrey    cterm=None
    hi          StatusLineNC    ctermfg=Grey        ctermbg=DarkGrey    cterm=None
    hi          VertSplit       ctermfg=Grey        ctermbg=NONE        cterm=None
    hi          LineNr          ctermfg=DarkGrey
    hi          ColorColumn     ctermbg=DarkRed
    hi          Visual          ctermbg=DarkGrey
    hi          Cursor          ctermbg=Yellow
    hi          CursorLine      ctermbg=Black       cterm=None

    hi          DiffAdd         ctermfg=White       ctermbg=Brown
    hi          DiffChange      ctermfg=DarkGrey    ctermbg=DarkBlue
    hi          DiffDelete      ctermfg=Grey        ctermbg=DarkRed
    hi          DiffText        ctermfg=White       ctermbg=DarkBlue

    hi          Directory       ctermfg=Blue
    hi          Search          ctermfg=DarkGrey    ctermbg=Yellow
    hi          Title           ctermfg=Magenta
endif

hi! link    Character       String
hi! link    NonText         Statement

hi! link    SpellBad        Error
hi! link    SpellCap        Todo
hi! link    SpellRare       Todo
hi! link    SpellLocal      Todo

hi! link    Pmenu           StatusLine
hi! link    PmenuSel        DiffAdd
hi! link    PmenuSbar       StatusLineNC
hi! link    PmenuThumb      StatusLine

hi! link    WarningMsg      Ignore
hi! link    ErrorMsg        Ignore

hi! link    Folded          StatusLine
hi! link    FoldColumn      LineNr
hi! link    SignColumn      LineNr

hi! link    Question        Identifier
hi! link    WildMenu        DiffAdd
hi! link    TagListFileName Directory
hi! link    IncSearch       Search
hi! link    SpecialKey      String
hi! link    MoreMsg         String


"   hi! ModeMsg
"   hi! VisualNOS
"   hi! Conceal
"   hi! TabLine
"   hi! TabLineSel
"   hi! TabLineFill
"   hi! MatchParen
