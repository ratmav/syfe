" syfe#whitespace#Clear {{{
function! syfe#whitespace#Clear()
  " check for modifiable buffer.
  if &modifiable
      " remove trailing whitespace.
        %s/\s\+$//e

      " clear the search term.
      noh

      " notify on clear.
      echo "syfe: cleared whitespace"
  else
    " notify on fixed buffer.
    echo "syfe: buffer is not modifiable."
  endif
endfunction
" }}}

" syfe#whitespace#Highlight {{{
function! syfe#whitespace#Highlight()
  " check for modifiable buffer.
  if &modifiable
    " highlight trailing whitespace.
    highlight TrailingWhitespace ctermbg=red guibg=red
    match TrailingWhitespace /\s\+$/
  endif
endfunction
" }}}
