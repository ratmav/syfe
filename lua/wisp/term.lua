local W = {}

-- Handle terminal settings
function W.setup(_)
  -- Only disable whitespace highlighting for terminal buffers
  vim.b.wisp_disable_whitespace = true
end

return W