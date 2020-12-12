" MarkdownHighlightSources() {{{
function! s:MarkdownHighlightSources(force)
    " Syntax highlight source code embedded in notes.
    " Look for code blocks in the current file
    let filetypes = {}
    for line in getline(1, '$')
        let ft = matchstr(line, '```\s*\zs[0-9A-Za-z_+-]*\ze.*')
        if !empty(ft) && ft !~# '^\d*$' | let filetypes[ft] = 1 | endif
    endfor
    if !exists('b:mkd_known_filetypes')
        let b:mkd_known_filetypes = {}
    endif
    if !exists('b:mkd_included_filetypes')
        " set syntax file name included
        let b:mkd_included_filetypes = {}
    endif
    if !a:force && (b:mkd_known_filetypes == filetypes || empty(filetypes))
        return
    endif

    " Now we're ready to actually highlight the code blocks.
    let startgroup = 'mkdCodeStart'
    let endgroup = 'mkdCodeEnd'
    for ft in keys(filetypes)
        if a:force || !has_key(b:mkd_known_filetypes, ft)
            let filetype = ft
            let group = 'mkdSnippet' . toupper(substitute(filetype, '[+-]', '_', 'g'))
            if !has_key(b:mkd_included_filetypes, filetype)
                let include = s:SyntaxInclude(filetype)
                let b:mkd_included_filetypes[filetype] = 1
            else
                let include = '@' . toupper(filetype)
            endif
            let command = 'syntax region %s matchgroup=%s start="^\s*```\s*%s.*$" matchgroup=%s end="\s*```$" keepend contains=%s%s'
            execute printf(command, group, startgroup, ft, endgroup, include, has('conceal') && get(g:, 'vim_markdown_conceal', 1) && get(g:, 'vim_markdown_conceal_code_blocks', 1) ? ' concealends' : '')
            execute printf('syntax cluster mkdNonListItem add=%s', group)

            let b:mkd_known_filetypes[ft] = 1
        endif
    endfor
endfunction
" }}}

" SyntaxInclude() {{{
function! s:SyntaxInclude(filetype)
    " Include the syntax highlighting of another {filetype}.
    let grouplistname = '@' . toupper(a:filetype)
    " Unset the name of the current syntax while including the other syntax
    " because some syntax scripts do nothing when "b:current_syntax" is set
    if exists('b:current_syntax')
        let syntax_save = b:current_syntax
        unlet b:current_syntax
    endif
    try
        execute 'syntax include' grouplistname 'syntax/' . a:filetype . '.vim'
        execute 'syntax include' grouplistname 'after/syntax/' . a:filetype . '.vim'
    catch /E484/
        " Ignore missing scripts
    endtry
    " Restore the name of the current syntax
    if exists('syntax_save')
        let b:current_syntax = syntax_save
    elseif exists('b:current_syntax')
        unlet b:current_syntax
    endif
    return grouplistname
endfunction
" }}}

" MarkdownRefreshSyntax() {{{
function! s:MarkdownRefreshSyntax(force)
    if &filetype =~# 'markdown' && line('$') > 1
        call s:MarkdownHighlightSources(a:force)
    endif
endfunction
" }}}

" MarkdownClearSyntaxVariables {{{
function! s:MarkdownClearSyntaxVariables()
    if &filetype =~# 'markdown'
        unlet! b:mkd_included_filetypes
    endif
endfunction
" }}}

" augroup markdown_syntax_highlighting {{{
augroup markdown_syntax_highlighting
    autocmd! * <buffer>

    autocmd BufWinEnter <buffer> call s:MarkdownRefreshSyntax(1)
    autocmd BufUnload <buffer> call s:MarkdownClearSyntaxVariables()
    autocmd BufWritePost <buffer> call s:MarkdownRefreshSyntax(0)
    autocmd InsertEnter,InsertLeave <buffer> call s:MarkdownRefreshSyntax(0)
    autocmd CursorHold,CursorHoldI <buffer> call s:MarkdownRefreshSyntax(0)
augroup END
" }}}
