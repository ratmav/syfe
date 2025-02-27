local S = {}

-- setup function to initialize the plugin
function S.setup(_)
  -- Create an autocommand group for whitespace highlighting
  local ws_group = vim.api.nvim_create_augroup("SyfeWhitespace", { clear = true })
  -- First, ensure terminals don't get highlighting
  vim.api.nvim_create_autocmd({"TermOpen", "TermEnter"}, {
    pattern = "*",
    callback = function()
      -- Disable whitespace highlighting for this buffer
      vim.b.syfe_disable_whitespace = true
    end,
    group = ws_group,
  })
  -- Set up whitespace highlighting but exclude terminal buffers
  vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost", "TextChanged", "InsertLeave", "WinEnter", "WinNew"}, {
    pattern = "*",
    callback = function()
      -- Skip terminal buffers or if explicitly disabled
      if vim.bo.buftype == "terminal" or vim.b.syfe_disable_whitespace then
        return
      end
      -- Only highlight in modifiable buffers
      if vim.bo.modifiable then
        -- Clear existing highlights in the current window
        for _, match_id in ipairs(vim.fn.getmatches()) do
          if match_id.group == "ErrorMsg" and match_id.pattern == "\\s\\+$" then
            pcall(function() vim.fn.matchdelete(match_id.id) end)
            -- Simplified error handling - we can safely ignore failures here
          end
        end
        -- Add new highlight
        vim.fn.matchadd("ErrorMsg", "\\s\\+$")
      end
    end,
    group = ws_group,
  })
  -- create unified command for removing whitespace and CRLF
  vim.api.nvim_create_user_command("SyfeWipe", function()
    require("syfe.whitespace").clear()
  end, {})
  -- Set up syntax highlighting for HCL files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "hcl",
    callback = function()
      -- Use dot notation for module paths to ensure cross-platform compatibility
      require("syntax.hcl").setup()
    end,
    group = vim.api.nvim_create_augroup("SyfeHCL", { clear = true }),
  })
end

return S