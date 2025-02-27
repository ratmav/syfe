local S = {}

-- highlight trailing whitespace
function S.highlight()
  if vim.bo.modifiable then
    vim.fn.matchadd("ErrorMsg", "\\s\\+$")
  end
end

-- clear both trailing whitespace and CRLF line endings
function S.clear()
  -- Check for terminal buffer
  if vim.bo.buftype == "terminal" then
    print("SyfeWipe: unsupported buffer type (terminal)")
    return
  end
  -- Check for non-modifiable buffer
  if not vim.bo.modifiable then
    print("SyfeWipe: unsupported buffer type (not modifiable)")
    return
  end
  -- Save cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- Count trailing whitespace instances before removal
  local ws_count = vim.fn.search('\\s\\+$', 'nw')
  -- Count CRLF instances before removal
  local crlf_count = vim.fn.search('\\r$', 'nw')
  -- Remove trailing whitespace
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  -- Remove CRLF line endings (convert to LF)
  -- This works regardless of host OS - it looks for \r at end of lines
  vim.cmd([[keeppatterns %s/\r$//e]])
  -- Restore cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  -- Show message about changes made (using print instead of notify)
  if ws_count > 0 or crlf_count > 0 then
    local msg = "SyfeWipe: "
    if ws_count > 0 then
      msg = msg .. "removed trailing whitespace"
      if crlf_count > 0 then
        msg = msg .. " and "
      end
    end
    if crlf_count > 0 then
      msg = msg .. "converted CRLF to LF"
    end
    print(msg)
  else
    print("SyfeWipe: no changes needed")
  end
end

return S