function! syfe#init#Init() abort
  command! SyfeCrlfClear :call syfe#crlf#Clear()
  command! SyfeWhitespaceClear :call syfe#whitespace#Clear()
endfunction
