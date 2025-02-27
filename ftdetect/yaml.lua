vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.yaml", "*.yml"},
  callback = function()
    vim.bo.filetype = "yaml"
  end
})