-- yaml-specific settings
local opt = vim.opt_local

-- Indentation settings (to ensure consistency with indentation)
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true

-- Setup folding based on indentation
opt.foldmethod = "indent"

-- Customize folding behavior
opt.foldenable = true   -- Enable folding
opt.foldlevel = 99      -- Keep all folds open by default
opt.foldcolumn = "auto" -- Show fold indicators in the gutter

-- Better fold text that shows yaml keys
opt.foldtext = [[substitute(getline(v:foldstart),'\\s*\\(.*\\)\\s*:.*','\\1:',' ').
                \ ' [' . (v:foldend-v:foldstart+1) . ' lines]']]

-- Improved folding by using a minimum of 2 lines for a fold
opt.foldminlines = 2    -- Don't fold if fewer than 2 lines

-- Make comments appear properly when folded
opt.foldignore = "#"    -- Ignore comment lines when folding