-- markdown-specific settings
vim.opt_local.conceallevel = 2

-- Enable folding for markdown files
vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.markdown_foldexpr(v:lnum)"

-- Fold markdown by headings
-- This function determines the fold level based on heading level
function _G.markdown_foldexpr(lnum)
  local line = vim.fn.getline(lnum)
  
  -- Check for ATX style headers (# Heading)
  local level = line:match("^%s*(#+)%s")
  if level then
    return ">" .. level:len()
  end
  
  -- Check for Setext style headers (Heading followed by === or ---)
  if lnum < vim.fn.line("$") then
    local next_line = vim.fn.getline(lnum + 1)
    if next_line:match("^=+%s*$") then
      return ">1"
    elseif next_line:match("^-+%s*$") then
      return ">2"
    end
  end
  
  -- Check for the beginning of a YAML frontmatter
  if lnum == 1 and line:match("^%-%-%-$") then
    return ">1"
  end
  
  -- Check for the end of a YAML frontmatter
  if line:match("^%-%-%-$") or line:match("^%.%.%.$") then
    if lnum > 1 and vim.fn.getline(1):match("^%-%-%-$") then
      return "<1"
    end
  end
  
  return "="
end

-- Set fold text to show heading with level indicator
vim.opt_local.foldtext = [[substitute(getline(v:foldstart), '^#\\+\\s*', '\\0['..(v:foldend-v:foldstart+1).' lines] ', '')]]

-- Enable folding but keep all folds open by default
vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldcolumn = "auto"