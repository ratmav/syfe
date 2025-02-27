-- hcl-specific settings

-- Set fold method to syntax for HCL files
vim.opt_local.foldmethod = "syntax"

-- Enable folding
vim.opt_local.foldenable = true

-- indentation settings
vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.expandtab = true

-- If folds are all closed when opening a file, open them initially
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = {"*.tf", "*.hcl", "*.tfvars", "*.nomad"},
  callback = function()
    -- Only execute if we're dealing with an HCL file
    if vim.bo.filetype == "hcl" then
      -- Open all folds when file is opened
      vim.cmd("normal! zR")
    end
  end,
  group = vim.api.nvim_create_augroup("SyfeHCLFolding", { clear = true }),
})