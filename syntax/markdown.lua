local api = vim.api

-- clear any existing syntax
if vim.b.current_syntax then
  return
end

-- load html syntax
api.nvim_command('runtime! syntax/html.lua')
if vim.b.current_syntax then
  vim.b.current_syntax = nil
end

-- markdown is case insensitive
api.nvim_command('syn case ignore')
api.nvim_command('syn sync linebreaks=1')
api.nvim_command('syn spell toplevel')

-- conceal setting for better readability
local conceal = ''
local concealends = ''
local concealcode = ''
if vim.fn.has('conceal') == 1 and vim.g.vim_markdown_conceal == 1 then
  conceal = ' conceal'
  concealends = ' concealends'
end
if vim.fn.has('conceal') == 1 and vim.g.vim_markdown_conceal_code_blocks == 1 then
  concealcode = ' concealends'
end

-- multiline emphasis
local oneline = ''
if vim.g.vim_markdown_emphasis_multiline ~= 0 then
  oneline = ' oneline'
end

-- text formatting
api.nvim_command('syn region mkdItalic matchgroup=mkdItalic start="\\%(\\*\\|_\\)" end="\\%(\\*\\|_\\)"')
api.nvim_command('syn region mkdBold matchgroup=mkdBold start="\\%(\\*\\*\\|__\\)" end="\\%(\\*\\*\\|__\\)"')
api.nvim_command('syn region mkdBoldItalic matchgroup=mkdBoldItalic start="\\%(\\*\\*\\*\\|___\\)" end="\\%(\\*\\*\\*\\|___\\)"')
api.nvim_command('syn region htmlItalic matchgroup=mkdItalic start="\\%(^\\|\\s\\)\\zs\\*\\ze[^\\\\\\*\\t ]\\%\\(\\%([^*]\\|\\\\\\*\\|\\n\\)*[^\\\\\\*\\t ]\\)\\?\\*\\_W" end="[^\\\\\\*\\t ]\\zs\\*\\ze\\_W" keepend contains=@Spell' .. oneline .. concealends)
api.nvim_command('syn region htmlItalic matchgroup=mkdItalic start="\\%(^\\|\\s\\)\\zs_\\ze[^\\\\_\\t ]" end="[^\\\\_\\t ]\\zs_\\ze\\_W" keepend contains=@Spell' .. oneline .. concealends)
api.nvim_command('syn region htmlBold matchgroup=mkdBold start="\\%(^\\|\\s\\)\\zs\\*\\*\\ze\\S" end="\\S\\zs\\*\\*" keepend contains=@Spell' .. oneline .. concealends)
api.nvim_command('syn region htmlBold matchgroup=mkdBold start="\\%(^\\|\\s\\)\\zs__\\ze\\S" end="\\S\\zs__" keepend contains=@Spell' .. oneline .. concealends)
api.nvim_command('syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\\%(^\\|\\s\\)\\zs\\*\\*\\*\\ze\\S" end="\\S\\zs\\*\\*\\*" keepend contains=@Spell' .. oneline .. concealends)
api.nvim_command('syn region htmlBoldItalic matchgroup=mkdBoldItalic start="\\%(^\\|\\s\\)\\zs___\\ze\\S" end="\\S\\zs___" keepend contains=@Spell' .. oneline .. concealends)

-- links
api.nvim_command('syn region mkdFootnotes matchgroup=mkdDelimiter start="\\[^" end="\\]"')
api.nvim_command('syn region mkdID matchgroup=mkdDelimiter start="\\[" end="\\]" contained oneline' .. conceal)
api.nvim_command('syn region mkdURL matchgroup=mkdDelimiter start="(" end=")" contained oneline' .. conceal)
api.nvim_command('syn region mkdLink matchgroup=mkdDelimiter start="\\\\\\@<!\\!\\?\\[\\ze[^]\\n]*\\n\\?[^]\\n]*\\][[(]" end="\\]" contains=@mkdNonListItem,@Spell nextgroup=mkdURL,mkdID skipwhite' .. concealends)

-- autolinks
api.nvim_command([[syn match mkdInlineURL /https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*/]])
api.nvim_command([[syn region mkdInlineURL matchgroup=mkdDelimiter start="(\(https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z0-9][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?[^] \t]*)\)\@=" end=")"]])
api.nvim_command([[syn region mkdInlineURL matchgroup=mkdDelimiter start="\\\@<!<\ze[a-z][a-z0-9,.-]\{1,22}:\/\/[^> ]*>" end=">"]])

-- link definitions
api.nvim_command([[syn region mkdLinkDef matchgroup=mkdDelimiter start="^ \{,3}\zs\[\^\@!" end="]:" oneline nextgroup=mkdLinkDefTarget skipwhite]])
api.nvim_command([[syn region mkdLinkDefTarget start="<\?\zs\S" excludenl end="\ze[>[:space:]\n]" contained nextgroup=mkdLinkTitle,mkdLinkDef skipwhite skipnl oneline]])
api.nvim_command([[syn region mkdLinkTitle matchgroup=mkdDelimiter start=+"+ end=+"+ contained]])
api.nvim_command([[syn region mkdLinkTitle matchgroup=mkdDelimiter start=+'+ end=+'+ contained]])
api.nvim_command([[syn region mkdLinkTitle matchgroup=mkdDelimiter start=(+ end=)+ contained]])

-- headings
api.nvim_command([[syn region htmlH1 matchgroup=mkdHeading start="^\s*#" end="$" contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn region htmlH2 matchgroup=mkdHeading start="^\s*##" end="$" contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn region htmlH3 matchgroup=mkdHeading start="^\s*###" end="$" contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn region htmlH4 matchgroup=mkdHeading start="^\s*####" end="$" contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn region htmlH5 matchgroup=mkdHeading start="^\s*#####" end="$" contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn region htmlH6 matchgroup=mkdHeading start="^\s*######" end="$" contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn match htmlH1 /^.\+\n=\+$/ contains=mkdLink,mkdInlineURL,@Spell]])
api.nvim_command([[syn match htmlH2 /^.\+\n-\+$/ contains=mkdLink,mkdInlineURL,@Spell]])

-- markdown elements
api.nvim_command([[syn match mkdLineBreak /  \+$/]])
api.nvim_command([[syn region mkdBlockquote start=/^\s*>/ end=/$/ contains=mkdLink,mkdInlineURL,mkdLineBreak,@Spell]])
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!`/ end=/`/]] .. concealcode)
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!``/ skip=/[^`]`[^`]/ end=/``/]] .. concealcode)
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start=/^\s*\z(`\{3,}\)[^`]*$/ end=/^\s*\z1`*\s*$/]] .. concealcode)
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start=/\(\([^\\]\|^\)\\\)\@<!\~\~/ end=/\(\([^\\]\|^\)\\\)\@<!\~\~/]] .. concealcode)
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start=/^\s*\z(\~\{3,}\)\s*[0-9A-Za-z_+-]*\s*$/ end=/^\s*\z1\~*\s*$/]] .. concealcode)
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start="<pre\(\|\_s[^>]*\)\\\@<!>" end="</pre>"]] .. concealcode)
api.nvim_command([[syn region mkdCode matchgroup=mkdCodeDelimiter start="<code\(\|\_s[^>]*\)\\\@<!>" end="</code>"]] .. concealcode)
api.nvim_command([[syn region mkdFootnote start="\[^" end="\]"]])
api.nvim_command([[syn match mkdCode /^\s*\n\(\(\s\{8,}[^ ]\|\t\t\+[^\t]\).*\n\)\+/]])
api.nvim_command([[syn match mkdCode /\%^\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/]])
api.nvim_command([[syn match mkdCode /^\s*\n\(\(\s\{4,}[^ ]\|\t\+[^\t]\).*\n\)\+/ contained]])
api.nvim_command([[syn match mkdListItem /^\s*\%([-*+]\|\d\+\.\)\ze\s\+/ contained]])
api.nvim_command([[syn region mkdListItemLine start="^\s*\%([-*+]\|\d\+\.\)\s\+" end="$" oneline contains=@mkdNonListItem,mkdListItem,@Spell]])
api.nvim_command([[syn region mkdNonListItemBlock start="\(\%^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@!\|\n\(\_^\_$\|\s\{4,}[^ ]\|\t+[^\t]\)\@!\)" end="^\(\s*\([-*+]\|\d\+\.\)\s\+\)\@=" contains=@mkdNonListItem,@Spell]])
api.nvim_command([[syn match mkdRule /^\s*\*\s\{0,1}\*\s\{0,1}\*\(\*\|\s\)*$/]])
api.nvim_command([[syn match mkdRule /^\s*-\s\{0,1}-\s\{0,1}-\(-\|\s\)*$/]])
api.nvim_command([[syn match mkdRule /^\s*_\s\{0,1}_\s\{0,1}_\(_\|\s\)*$/]])

-- yaml frontmatter support
if vim.g.vim_markdown_frontmatter == 1 then
  api.nvim_command([[syn include @yamlTop syntax/yaml.vim]])
  api.nvim_command([[syn region Comment matchgroup=mkdDelimiter start="\%^---$" end="^\(---\|\.\.\.\)$" contains=@yamlTop keepend]])
  vim.b.current_syntax = nil
end

-- toml frontmatter support
if vim.g.vim_markdown_toml_frontmatter == 1 then
  api.nvim_command([[syn include @tomlTop syntax/toml.vim]])
  api.nvim_command([[syn region Comment matchgroup=mkdDelimiter start="\%^+++$" end="^+++$" transparent contains=@tomlTop keepend]])
  vim.b.current_syntax = nil
end

-- json frontmatter support
if vim.g.vim_markdown_json_frontmatter == 1 then
  api.nvim_command([[syn include @jsonTop syntax/json.vim]])
  api.nvim_command([[syn region Comment matchgroup=mkdDelimiter start="\%^{$" end="^}$" contains=@jsonTop keepend]])
  vim.b.current_syntax = nil
end

-- math support
if vim.g.vim_markdown_math == 1 then
  api.nvim_command([[syn include @tex syntax/tex.vim]])
  api.nvim_command([[syn region mkdMath start="\\\@<!\$" end="\$" skip="\\\$" contains=@tex keepend]])
  api.nvim_command([[syn region mkdMath start="\\\@<!\$\$" end="\$\$" skip="\\\$" contains=@tex keepend]])
end

-- strikethrough
if vim.g.vim_markdown_strikethrough == 1 then
  api.nvim_command([[syn region mkdStrike matchgroup=htmlStrike start="\%(\~\~\)" end="\%(\~\~\)"]] .. concealends)
  api.nvim_command([[hi def link mkdStrike htmlStrike]])
end

-- define groups
api.nvim_command([[syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,mkdStrike]])

-- highlighting
api.nvim_command([[hi def link mkdString String]])
api.nvim_command([[hi def link mkdCode String]])
api.nvim_command([[hi def link mkdCodeDelimiter String]])
api.nvim_command([[hi def link mkdCodeStart String]])
api.nvim_command([[hi def link mkdCodeEnd String]])
api.nvim_command([[hi def link mkdFootnote Comment]])
api.nvim_command([[hi def link mkdBlockquote Comment]])
api.nvim_command([[hi def link mkdListItem Identifier]])
api.nvim_command([[hi def link mkdRule Identifier]])
api.nvim_command([[hi def link mkdLineBreak Visual]])
api.nvim_command([[hi def link mkdFootnotes htmlLink]])
api.nvim_command([[hi def link mkdLink htmlLink]])
api.nvim_command([[hi def link mkdURL htmlString]])
api.nvim_command([[hi def link mkdInlineURL htmlLink]])
api.nvim_command([[hi def link mkdID Identifier]])
api.nvim_command([[hi def link mkdLinkDef mkdID]])
api.nvim_command([[hi def link mkdLinkDefTarget mkdURL]])
api.nvim_command([[hi def link mkdLinkTitle htmlString]])
api.nvim_command([[hi def link mkdDelimiter Delimiter]])

vim.b.current_syntax = 'markdown'