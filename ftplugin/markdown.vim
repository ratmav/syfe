let b:fenced_block = 0
let b:front_matter = 0
let s:vim_markdown_folding_level = get(g:, "vim_markdown_folding_level", 1)

" s:is_mkdCode {{{
function! s:is_mkdCode(lnum)
  let name = synIDattr(synID(a:lnum, 1, 0), 'name')
  return (name =~ '^mkd\%(Code$\|Snippet\)' || name != '' && name !~ '^\%(mkd\|html\)')
endfunction
" }}}

" Foldexpr_markdown {{{
function! Foldexpr_markdown(lnum)
    if (a:lnum == 1)
        let l0 = ''
    else
        let l0 = getline(a:lnum-1)
    endif

    " keep track of fenced code blocks
    if l0 =~ '````*' || l0 =~ '\~\~\~\~*'
        if b:fenced_block == 0
            let b:fenced_block = 1
        elseif b:fenced_block == 1
            let b:fenced_block = 0
        endif
    elseif g:vim_markdown_frontmatter == 1
        if b:front_matter == 1
            if l0 == '---'
                let b:front_matter = 0
            endif
        elseif a:lnum == 2
            if l0 == '---'
                let b:front_matter = 1
            endif
        endif
    endif

    if b:fenced_block == 1 || b:front_matter == 1
        " keep previous foldlevel
        return '='
    endif

    let l2 = getline(a:lnum+1)
    if  l2 =~ '^==\+\s*' && !s:is_mkdCode(a:lnum+1)
        " next line is underlined (level 1)
        return '>1'
    elseif l2 =~ '^--\+\s*' && !s:is_mkdCode(a:lnum+1)
        " next line is underlined (level 2)
        if s:vim_markdown_folding_level >= 2
            return '>1'
        else
            return '>2'
        endif
    endif

    let l1 = getline(a:lnum)
    if l1 =~ '^#' && !s:is_mkdCode(a:lnum)
        " fold level according to option
        if s:vim_markdown_folding_level == 1 || matchend(l1, '^#\+') > s:vim_markdown_folding_level
            if a:lnum == line('$')
                return matchend(l1, '^#\+') - 1
            else
                return -1
            endif
        else
            " headers are not folded
            return 0
        endif
    endif

    if l0 =~ '^#' && !s:is_mkdCode(a:lnum-1)
        " previous line starts with hashes
        return '>'.matchend(l0, '^#\+')
    else
        " keep previous foldlevel
        return '='
    endif
endfunction
" }}}

" s:MarkdownSetupFolding {{{
function! s:MarkdownSetupFolding()
  if !get(g:, "vim_markdown_folding_disabled", 0)
      if get(g:, "vim_markdown_folding_style_pythonic", 0)
          if get(g:, "vim_markdown_override_foldtext", 1)
              setlocal foldtext=Foldtext_markdown()
          endif
      endif
      setlocal foldexpr=Foldexpr_markdown(v:lnum)
      setlocal foldmethod=expr
  endif
endfunction
" }}}

" s:MarkdownSetupFoldLevel {{{
function! s:MarkdownSetupFoldLevel()
  if get(g:, "vim_markdown_folding_style_pythonic", 0)
      " set default foldlevel
      execute "setlocal foldlevel=".s:vim_markdown_folding_level
  endif
endfunction
" }}}

call s:MarkdownSetupFoldLevel()
call s:MarkdownSetupFolding()

" augroup Mkd {{{
augroup Mkd
  " These autocmds need to be kept in sync with the autocmds calling s:MarkdownRefreshSyntax in ftplugin/markdown.vim.
  autocmd BufWinEnter,BufWritePost <buffer> call s:MarkdownSetupFolding()
  autocmd InsertEnter,InsertLeave <buffer> call s:MarkdownSetupFolding()
  autocmd CursorHold,CursorHoldI <buffer> call s:MarkdownSetupFolding()
augroup END
" }}}
