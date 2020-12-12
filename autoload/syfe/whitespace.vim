" syfe#whitespace#Toggle {{{
let g:syfe_whitespace_toggle = 0
function! syfe#whitespace#Toggle()
  if &modifiable
    if g:syfe_whitespace_toggle
      " remove trailing whitespace in modifiable buffers.
        %s/\s\+$//e

      " clear the search term.
      noh

      " notify
      echo "syfe: cleared whitespace"

      let g:syfe_whitespace_toggle = 0
    else
      " highlight and match trailing whitespace.
      highlight Extrawhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+$/

      let g:syfe_whitespace_toggle = 1
    endif
  else
    echo "syfe: buffer isn't modifiable."
  endif
endfunction
" }}}
