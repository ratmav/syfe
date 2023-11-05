" syfe#crlf#Clear {{{
function! syfe#crlf#Clear() abort
  " check for modifiable buffer.
  if &modifiable
      " calling substitute (%s) had the side effect of moving the cursor
      " and overwriting the previous search, *if called outside of a
      " function*. calling substitute from within a function automatically
      " restores the last-used search term.
      " vint: -ProhibitCommandRelyOnUser
      " vint: -ProhibitCommandWithUnintendedSideEffect
      " remove crlf line endings.
        %s/\r//e
      " vint: +ProhibitCommandRelyOnUser
      " vint: +ProhibitCommandWithUnintendedSideEffect

      " clear the search term.
      noh

      " notify on clear.
      echo 'syfe: cleared crlf line endings.'
  else
    " notify on fixed buffer.
    echo 'syfe: buffer is not modifiable.'
  endif
endfunction
" }}}
