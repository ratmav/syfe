" Example Vimscript file to demonstrate syntax highlighting and folding

" Basic settings
set nocompatible
set number
set relativenumber
set cursorline
set wildmenu
set showmatch
set incsearch
set hlsearch

" Indentation settings
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
set autoindent
set smartindent

" File type detection
filetype on
filetype plugin on
filetype indent on

" Syntax highlighting
syntax enable

" Colors and UI
set background=dark
if has('termguicolors')
  set termguicolors
endif

" Status line configuration " {{
set laststatus=2
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=%#Visual#\ %n\  
set statusline+=%#Visual#\ %f\  
set statusline+=%#Visual#\ %{&modified?'[+]':''}
set statusline+=%#Visual#\ %{&readonly?'[RO]':''} 
set statusline+=%=
set statusline+=%#Visual#\ %y\  
set statusline+=%#Visual#\ %{&fileencoding?&fileencoding:&encoding}\ 
set statusline+=%#Visual#\ %3p%%\ \ %l:\ %3c\  
" }}

" Key mappings
let mapleader = ","

" Function to toggle relative line numbers " {{
function! ToggleRelativeNumber()
    if &relativenumber
        set norelativenumber
    else
        set relativenumber
    endif
endfunction

nnoremap <leader>n :call ToggleRelativeNumber()<CR>
" }}

" Function to toggle syntax highlighting " {{
function! ToggleSyntax()
    if exists("g:syntax_on")
        syntax off
        let g:syntax_on=0
    else
        syntax enable
        let g:syntax_on=1
    endif
endfunction

nnoremap <leader>s :call ToggleSyntax()<CR>
" }}

" Function to toggle search highlighting " {{
function! ToggleHLSearch()
    if &hlsearch
        set nohlsearch
    else
        set hlsearch
    endif
endfunction

nnoremap <leader>h :call ToggleHLSearch()<CR>
" }}

" Custom autocmd group
augroup FileTypeSpecific " {{
    autocmd!
    autocmd FileType python setlocal foldmethod=indent
    autocmd FileType vim setlocal foldmethod=marker
    autocmd FileType markdown setlocal conceallevel=2
    
    " Set indentation for specific file types
    autocmd FileType html,css,javascript,json setlocal tabstop=2 shiftwidth=2
    autocmd FileType go setlocal noexpandtab tabstop=8 shiftwidth=8
    
    " Auto remove trailing whitespace on save for certain filetypes
    autocmd BufWritePre *.py,*.vim,*.js,*.html,*.css,*.json,*.md :%s/\s\+$//e
augroup END " }}

" Example plugin initialization " {{
" Check if vim-plug is installed, install if not
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin declarations
call plug#begin('~/.vim/plugged')
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-surround'
  Plug 'preservim/nerdtree'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

" Plugin specific settings
map <C-n> :NERDTreeToggle<CR>
nnoremap <C-p> :Files<CR>
" }}

" Custom commands " {{
command! -nargs=0 Format :call CocAction('format')
command! -nargs=0 OrganizeImports :call CocAction('runCommand', 'editor.action.organizeImport')
command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Example of a command that removes trailing whitespaces
command! RemoveTrailingWhitespace :%s/\s\+$//e
" }}