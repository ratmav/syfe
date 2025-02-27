-- Terminal handling group
local term_group = vim.api.nvim_create_augroup("SyfeTerminal", { clear = true })

-- Disable whitespace highlighting for terminals
vim.api.nvim_create_autocmd({"TermOpen", "TermEnter", "BufEnter"}, {
  pattern = "*",
  callback = function()
    -- Only run on terminal buffers
    if vim.bo.buftype ~= "terminal" then
      return
    end
    
    -- Disable whitespace highlighting
    vim.b.syfe_disable_whitespace = true
    
    -- Clear any existing whitespace matches in this buffer
    for _, match_id in ipairs(vim.fn.getmatches()) do
      if match_id.group == "ErrorMsg" and match_id.pattern == "\\s\\+$" then
        pcall(function() vim.fn.matchdelete(match_id.id) end)
      end
    end
  end,
  group = term_group,
})

-- automatically load the plugin
require("syfe").setup()