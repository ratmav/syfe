syfe
====

(sy)ntax highlighting, (f)olding, and whit(e)space management

## installation

use git or your plugin manager of choice to install syfe.

## supported languages

* go
    * autoindentation and (8 spaces) per tab.
* makefile
    * autoindentation and (8 spaces) per tab.
* markdown
    * syntax highlighting, including code blocks.
* python
    * indentation-based folding.
* vimscript
    * folding via [explicit comment markers](https://learnvimscriptthehardway.stevelosh.com/chapters/18.html#grouping): `" {{` and `" }}` start and stop a fold, respectively.
* yaml
    * delimiter-based autoindentation.

## commands

commands are provided for mapping as desired.

### `SyfeWhitespaceClear`: finds and removes trailing whitespace.

# acknowledgements

* [ben williams'](https://plasticboy.com/), [vim-markdown](https://github.com/plasticboy/vim-markdown), as the starting point for markdown support.
* [steve losh's](https://stevelosh.com/) book, [learn vimscript the hard way](https://learnvimscriptthehardway.stevelosh.com/), was a great and useful read.
