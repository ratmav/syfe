syfe
====

(sy)ntax highlighting, (f)olding, and whit(e)space management

## installation

use git or your plugin manager of choice to install syfe.

## features

### terminal

* disables whitespace highlighting in terminals

### languages

* go
    * autoindentation; 8 spaces per tab.
* hcl
    * syntax highlighting and folding for HashiCorp Configuration Language (HCL).
    * supports terraform/opentofu (.tf, .tfvars) and nomad (.nomad) files.
    * indentation; 2 spaces per tab.
* makefile
    * autoindentation; 8 spaces per tab.
* markdown
    * basic syntax highlighting, fenced code blocks.
* python
    * indentation-based folding.
* yaml
    * autoindention on -, =, and other key characters.
    * no autoindent on # to make block commenting easier.

## whitespace management

### display

syfe will highlight trailing whitespace when entering a **modifiable** buffer.

### commands

* `SyfeWipe`: call to remove any trailing whitespace and CRLF line endings in a **modifiable** buffer.

#### mapping example

add the following to your vim configuration to clean up a file by pressing Leader-w:

```lua
-- syfe:
vim.keymap.set("n", "<Leader>w", "<cmd>SyfeWipe<CR>", { silent = true })
```

## development

this project uses a Makefile to automate common development tasks.

to see all available tasks:

```bash
make help
```

### makefile tab completion (optional)

add the following function to your bash config:

```bash
_make_completion() {
    local cur prev targets

    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    # Parse Makefile targets
    targets=$(make -qp | awk -F':' '/^[a-zA-Z0-9][^$#\/\t=]*:([^=]|$)/ {split($1,A,/ /);print A[1]}' | sort -u)

    COMPREPLY=( $(compgen -W "${targets}" -- ${cur}) )
    return 0
}
complete -F _make_completion make
```