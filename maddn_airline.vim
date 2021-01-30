scriptencoding utf-8

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

function! s:ColorArray(colorfg, colorbg)
  return [ a:colorfg[1], a:colorbg[1], a:colorfg[0], a:colorbg[0] ]
endfunction

function! s:AddWarnAndError(color_map)
  let a:color_map.airline_warning = s:ColorArray( s:DarkGrey, s:Grey  )
  let a:color_map.airline_error   = s:ColorArray( s:DarkGrey, s:Red   )
endfunction

function! s:ColorMap(az, by, cx)
  let color_map = airline#themes#generate_color_map(a:az, a:by, a:cx)
  call s:AddWarnAndError(color_map)
  return color_map
endfunction

function! s:ColorMapOverride(section, color_array)
  let color_map = { a:section: a:color_array }
  call s:AddWarnAndError(color_map)
  return color_map
endfunction

let s:N1        = s:ColorArray( s:DarkGrey,     s:DarkYellow  )
let s:N2        = s:ColorArray( s:Grey,         s:DarkGrey    )
let s:N3        = s:ColorArray( s:DarkCyan,     s:Black       )

let s:I1        = s:ColorArray( s:DarkGrey,     s:Cyan        )
let s:I2        = s:ColorArray( s:DarkGrey,     s:DarkBlue    )
let s:I3        = s:N3

let s:V1        = s:ColorArray( s:DarkGrey,     s:Magenta     )
let s:V2        = s:N2
let s:V3        = s:N3

let s:IA1       = s:ColorArray( s:Black,        s:DarkGrey    )
let s:IA2       = s:ColorArray( s:DarkGrey,     s:Black       )
let s:IA3       = s:ColorArray( s:Black,        s:DarkGrey    )

let s:Mod       = s:ColorArray( s:DarkGrey,     s:DarkRed     )
let s:IAMod     = s:ColorArray( s:DarkGrey,     s:Grey        )

let s:ModMap    = s:ColorMapOverride( 'airline_c', s:Mod )

let g:airline#themes#maddn_airline#palette = {
  \   'normal':             s:ColorMap( s:N1,   s:N2,   s:N3),
  \   'insert':             s:ColorMap( s:I1,   s:I2,   s:I3),
  \   'replace':            s:ColorMap( s:I1,   s:I2,   s:I3),
  \   'visual':             s:ColorMap( s:V1,   s:V2,   s:V3),
  \   'inactive':           s:ColorMap( s:IA1,  s:IA2,  s:IA3),
  \   'normal_modified':    s:ModMap,
  \   'insert_modified':    s:ModMap,
  \   'replace_modified':   s:ModMap,
  \   'visual_modified':    s:ModMap,
  \   'inactive_modified':  s:ColorMapOverride( 'airline_c', s:IAMod ),
  \   'accents':            { 'red':  [ s:Red[1], '', s:Red[0], '' ] }
  \ }
