syfe
====

(sy)ntax highlighting, (f)olding, and whit(e)space management

## installation

use git or your plugin manager of choice to install syfe.

## syntax, indentation, and folding

* go
    * autoindentation; 8 spaces per tab.
* makefile
    * autoindentation; 8 spaces per tab.
* markdown
    * syntax highlighting, including fenced code blocks.
* python
    * indentation-based folding.
* vimscript
    * folding via [explicit comment markers](https://learnvimscriptthehardway.stevelosh.com/chapters/18.html#grouping): `" {{` and `" }}` start and stop a fold, respectively.
* yaml
    * autoindention on -, =, 0, or # characters.

## whitespace management

### display

syfe will highlight trailing whitespace when entering a **modifiable** buffer.

### commands

* `SyfeWhitespaceClear`: call to remove any trailing whitespace in a **modifiable** buffer.

#### mapping example

add the following to your vim configuration to remove trailing whitespace by pressing Leader-w:

```vimscript
" syfe:
nnoremap <silent><Leader>w :execute 'SyfeWhitespaceClear'<CR>
```

## acknowledgements

* [ben williams'](https://plasticboy.com/), [vim-markdown](https://github.com/plasticboy/vim-markdown), as the starting point for markdown support.
* [steve losh's](https://stevelosh.com/) book, [learn vimscript the hard way](https://learnvimscriptthehardway.stevelosh.com/), was a great and useful read.
