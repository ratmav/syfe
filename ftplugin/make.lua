-- Makefile-specific settings
vim.opt_local.tabstop = 8
vim.opt_local.shiftwidth = 8
vim.opt_local.expandtab = false

-- Enable expression folding for Makefiles
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.make_foldexpr(v:lnum)"

-- Function to determine fold level based on Makefile targets
function _G.make_foldexpr(lnum)
  local line = vim.fn.getline(lnum)
  local next_line = ""
  
  if lnum < vim.fn.line("$") then
    next_line = vim.fn.getline(lnum + 1)
  end
  
  -- If this line is a target definition (ends with : and isn't a comment)
  if line:match("^[^#].*:%s*$") then
    -- It's a target line, start a fold
    return ">1"
  end
  
  -- If this is a comment line before a target, include it in the target's fold
  if line:match("^#") and next_line:match("^[^#].*:%s*$") then
    return ">1"
  end
  
  -- If this line begins with a tab and isn't empty, it's part of a target's commands
  if line:match("^\t") and line:match("[^\t]") then
    return "="
  end
  
  -- If this is a blank line and the next line is a target or comment before a target
  if line:match("^%s*$") and
     (next_line:match("^[^#].*:%s*$") or
      (next_line:match("^#") and lnum + 2 <= vim.fn.line("$") and 
       vim.fn.getline(lnum + 2):match("^[^#].*:%s*$"))) then
    return "<1"
  end
  
  -- Default to continuing the current fold level
  return "="
end

-- Set custom fold text to display target name and # of lines
vim.opt_local.foldtext = [[substitute(getline(v:foldstart), '\\(.*\\):.*', '\\1:', '') . ' [' . (v:foldend-v:foldstart+1) . ' lines]']]

-- Enable folding but keep all folds open by default
vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldcolumn = "auto"