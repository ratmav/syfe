local S = {}

-- Handle terminal settings
function S.setup(_)
  -- Only disable whitespace highlighting for terminal buffers
  vim.b.syfe_disable_whitespace = true
end

return S