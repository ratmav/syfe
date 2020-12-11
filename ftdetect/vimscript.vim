" augroup vimscript_folding {{{
augroup vimscript_folding
    autocmd! *

    " use '{{{' and '}}}' comments to set markers.
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}
