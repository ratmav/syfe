-- Detect HCL files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.hcl",
  callback = function() vim.bo.filetype = "hcl" end
})

-- Detect Nomad files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.nomad",
  callback = function() vim.bo.filetype = "hcl" end
})

-- Detect Terraform files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.tf", "*.tfvars"},
  callback = function() vim.bo.filetype = "hcl" end
})

-- Detect Terraform state files as JSON
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.tfstate", "*.tfstate.backup"},
  callback = function() vim.bo.filetype = "json" end
})

-- Detect Terraform config files
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {".terraformrc", "terraform.rc"},
  callback = function() vim.bo.filetype = "hcl" end
})