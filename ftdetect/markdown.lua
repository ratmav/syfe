vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"*.markdown", "*.md", "*.mdown", "*.mkd", "*.mkdn"},
  callback = function()
    vim.bo.filetype = "markdown"
  end
})