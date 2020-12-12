augroup syfe_whitespace_highlight
  autocmd!

  autocmd BufEnter * call syfe#whitespace#Highlight()
augroup END

call syfe#init#Init()
