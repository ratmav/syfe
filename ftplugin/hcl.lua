-- hcl-specific settings

-- Set fold method to syntax for HCL files
vim.opt_local.foldmethod = "syntax"

-- Enable folding but keep all folds open by default
vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldcolumn = "auto"

-- indentation settings
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true