-- yaml-specific indentation
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- set indentkeys for yaml (removed # to avoid auto-indenting comments)
vim.opt_local.indentkeys:append("0-,0=,!^F,o,O")