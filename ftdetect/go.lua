vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.go",
  callback = function()
    vim.bo.filetype = "go"
  end
})