wisp
====

(w)h(i)te(sp)ace management

## installation

use git or your plugin manager of choice to install wisp.

## features

* disables whitespace highlighting in terminals.
* highlights trailing whitespace when entering a **modifiable** buffer.
    * terminal buffers are *not* modifiable.

### commands

* `:Wisp`: call to remove any trailing whitespace and crlf line endings in a **modifiable** buffer.

#### mapping example

add the following to your vim configuration to clean up a file by pressing Leader-w:

```lua
-- wisp:
vim.keymap.set("n", "<Leader>w", "<cmd>Wisp<CR>", { silent = true })
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
