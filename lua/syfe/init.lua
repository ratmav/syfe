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
      -- Instead of trying to require the module, just call the vim commands directly
      -- This avoids module path issues between different Neovim versions
      vim.cmd([[
        if exists('b:current_syntax')
          finish
        endif
        
        " Variables and paths
        syn match hclVariable /\<[A-Za-z0-9_.\[\]*-]\+\>/
        
        " Functions
        syn match hclParenthesis /(/
        syn match hclFunction    /\w\+(/ contains=hclParenthesis
        
        " Keywords
        syn keyword hclKeyword for in if
        
        " Strings with escape sequences and interpolation
        syn region hclString start=/"/ end=/"/ contains=hclEscape,hclInterpolation
        syn region hclString start=/<<-\?\z([A-Z]\+\)/ end=/^\s*\z1/ contains=hclEscape,hclInterpolation
        
        " Escape sequences
        syn match hclEscape /\\n/
        syn match hclEscape /\\r/
        syn match hclEscape /\\t/
        syn match hclEscape /\\"/
        syn match hclEscape /\\\\/
        syn match hclEscape /\\u\x\{4\}/
        syn match hclEscape /\\u\x\{8\}/
        
        " Numbers
        syn match hclNumber /\<\d\+\%([eE][+-]\?\d\+\)\?\>/
        syn match hclNumber /\<\d*\.\d\+\%([eE][+-]\?\d\+\)\?\>/
        syn match hclNumber /\<0[xX]\x\+\>/
        
        " Constants
        syn keyword hclConstant true false null
        
        " String interpolation
        syn region hclInterpolation start=/\${/ end=/}/ contained contains=hclInterpolation
        
        " Comments
        syn region hclComment start=/\/\// end=/$/    contains=hclTodo
        syn region hclComment start=/\#/   end=/$/    contains=hclTodo
        syn region hclComment start=/\/\*/ end=/\*\// contains=hclTodo
        
        " Attributes and blocks
        syn match hclAttributeName /\w\+/ contained
        syn match hclAttribute     /^[^=]\+=/ contains=hclAttributeName,hclComment,hclString
        
        syn match hclBlockName /\w\+/ contained
        syn match hclBlock     /^[^=]\+{/ contains=hclBlockName,hclComment,hclString
        
        " Todo items in comments
        syn keyword hclTodo TODO FIXME XXX DEBUG NOTE contained
        
        " Set up folding
        syn sync fromstart
        syn region hclFold start="{" end="}" transparent fold containedin=ALLBUT,hclComment
        
        " Highlighting links
        hi def link hclVariable      PreProc
        hi def link hclFunction      Function
        hi def link hclKeyword       Keyword
        hi def link hclString        String
        hi def link hclEscape        Special
        hi def link hclNumber        Number
        hi def link hclConstant      Constant
        hi def link hclInterpolation PreProc
        hi def link hclComment       Comment
        hi def link hclTodo          Todo
        hi def link hclBlockName     Structure
        
        let b:current_syntax = 'hcl'
      ]])
    end,
    group = vim.api.nvim_create_augroup("SyfeHCL", { clear = true }),
  })
end

return S