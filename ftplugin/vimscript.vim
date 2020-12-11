" augroup vimscript_folding {{{
augroup vimscript_folding
    autocmd! * <buffer>

    " use '{{{' and '}}}' comments to set markers.
    autocmd FileType vimscript setlocal foldmethod=marker
augroup END
" }}}
