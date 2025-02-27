-- HCL syntax highlighting
-- Based on https://github.com/jvirtanen/vim-hcl

local M = {}

function M.setup()
  -- Prevent reloading if already loaded
  vim.cmd([[
    if exists('b:current_syntax')
      finish
    endif
  ]])
  
  -- Variables and paths
  vim.cmd([[syn match hclVariable /\<[A-Za-z0-9_.\[\]*-]\+\>/]])
  
  -- Functions
  vim.cmd([[
    syn match hclParenthesis /(/
    syn match hclFunction    /\w\+(/ contains=hclParenthesis
  ]])
  
  -- Keywords
  vim.cmd([[syn keyword hclKeyword for in if]])
  
  -- Strings with escape sequences and interpolation
  vim.cmd([[
    syn region hclString start=/"/ end=/"/ contains=hclEscape,hclInterpolation
    syn region hclString start=/<<-\?\z([A-Z]\+\)/ end=/^\s*\z1/ contains=hclEscape,hclInterpolation
  ]])
  
  -- Escape sequences
  vim.cmd([[
    syn match hclEscape /\\n/
    syn match hclEscape /\\r/
    syn match hclEscape /\\t/
    syn match hclEscape /\\"/
    syn match hclEscape /\\\\/
    syn match hclEscape /\\u\x\{4\}/
    syn match hclEscape /\\u\x\{8\}/
  ]])
  
  -- Numbers
  vim.cmd([[
    syn match hclNumber /\<\d\+\%([eE][+-]\?\d\+\)\?\>/
    syn match hclNumber /\<\d*\.\d\+\%([eE][+-]\?\d\+\)\?\>/
    syn match hclNumber /\<0[xX]\x\+\>/
  ]])
  
  -- Constants
  vim.cmd([[syn keyword hclConstant true false null]])
  
  -- String interpolation
  vim.cmd([[syn region hclInterpolation start=/\${/ end=/}/ contained contains=hclInterpolation]])
  
  -- Comments
  vim.cmd([[
    syn region hclComment start=/\/\// end=/$/    contains=hclTodo
    syn region hclComment start=/\#/   end=/$/    contains=hclTodo
    syn region hclComment start=/\/\*/ end=/\*\// contains=hclTodo
  ]])
  
  -- Attributes and blocks
  vim.cmd([[
    syn match hclAttributeName /\w\+/ contained
    syn match hclAttribute     /^[^=]\+=/ contains=hclAttributeName,hclComment,hclString
    
    syn match hclBlockName /\w\+/ contained
    syn match hclBlock     /^[^=]\+{/ contains=hclBlockName,hclComment,hclString
  ]])
  
  -- Todo items in comments
  vim.cmd([[syn keyword hclTodo TODO FIXME XXX DEBUG NOTE contained]])
  
  -- Set up folding
  vim.cmd([[
    syn sync fromstart
    syn region hclFold start="{" end="}" transparent fold containedin=ALLBUT,hclComment
  ]])
  
  -- Highlighting links
  vim.cmd([[
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
  ]])
  
  -- Mark as loaded
  vim.cmd([[let b:current_syntax = 'hcl']])
end

return M