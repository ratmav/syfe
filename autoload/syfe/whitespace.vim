function! syfe#whitespace#Clear()
  " find and remove trailing whitespace.
  %s/\s\+$//e

  " clear the search term.
  noh

  " notify.
  echo "cleared whitespace"
endfunction
