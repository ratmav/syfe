vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = {"[Mm]akefile", "[Mm]akefile.*", "*.mk"},
  callback = function()
    vim.bo.filetype = "make"
  end
})