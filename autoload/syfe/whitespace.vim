" syfe#whitespace#Clear {{{
function! syfe#whitespace#Clear() abort
  " check for modifiable buffer.
  if &modifiable
      " calling substitute (%s) had the side effect of moving the cursor
      " and overwriting the previous search, *if called outside of a
      " function*. calling substitute from within a function automatically
      " restores the last-used search term.
      " vint: -ProhibitCommandRelyOnUser
      " vint: -ProhibitCommandWithUnintendedSideEffect
      " remove trailing whitespace.
        %s/\s\+$//e
      " vint: +ProhibitCommandRelyOnUser
      " vint: +ProhibitCommandWithUnintendedSideEffect

      " clear the search term.
      noh

      " notify on clear.
      echo 'syfe: cleared whitespace'
  else
    " notify on fixed buffer.
    echo 'syfe: buffer is not modifiable.'
  endif
endfunction
" }}}

" syfe#whitespace#Highlight {{{
function! syfe#whitespace#Highlight() abort
  " check for modifiable buffer.
  if &modifiable
    " highlight trailing whitespace.
    highlight TrailingWhitespace ctermbg=red guibg=red
    match TrailingWhitespace /\s\+$/
  endif
endfunction
" }}}
