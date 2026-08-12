-- Run through tests/run.sh, which isolates the state directories first
local repo = assert(vim.env.DDLC_REPO, "DDLC_REPO has to point at the checkout")
vim.opt.runtimepath:prepend(repo)

local ddlc = require("ddlc")
local palette = require("ddlc.palette")

local failed = 0
local function check(name, ok, got)
  if ok then
    print("ok   " .. name)
  else
    failed = failed + 1
    print("FAIL " .. name .. (got ~= nil and ("  got: " .. vim.inspect(got)) or ""))
  end
end

local function hl(group)
  return vim.api.nvim_get_hl(0, { name = group })
end
local function hex(n)
  return n and string.format("#%06X", n) or nil
end
local function reset()
  ddlc.config = vim.deepcopy(ddlc.defaults)
end

-- The dark variant, which is what a bare :colorscheme ddlc gives a terminal that says nothing
reset()
vim.o.background = "dark"
vim.cmd("colorscheme ddlc")
local dark = palette.dark

check("names itself", vim.g.colors_name == "ddlc", vim.g.colors_name)
check("Normal carries the ground", hex(hl("Normal").bg) == dark.base00, hex(hl("Normal").bg))
check("Normal carries the text", hex(hl("Normal").fg) == dark.base05, hex(hl("Normal").fg))
check("comments are italic", hl("Comment").italic == true, hl("Comment"))
check("treesitter is covered", hex(hl("@keyword").fg) == dark.base0E, hex(hl("@keyword").fg))
check("markup is covered", hl("@markup.heading").bold == true, hl("@markup.heading"))
check("diagnostics are covered", hex(hl("DiagnosticError").fg) == dark.base08, hex(hl("DiagnosticError").fg))
check("the squiggle carries the level", hl("DiagnosticUnderlineWarn").undercurl == true, hl("DiagnosticUnderlineWarn"))
check("semantic tokens link into the parser", vim.api.nvim_get_hl(0, { name = "@lsp.type.class" }).link == "@type", vim.api.nvim_get_hl(0, { name = "@lsp.type.class" }))
check("telescope is on by default", hex(hl("TelescopeSelection").bg) == dark.base02, hex(hl("TelescopeSelection").bg))
check("the terminal gets the same colours", vim.g.terminal_color_4 == dark.base0D, vim.g.terminal_color_4)

-- Transparency clears the grounds painted with base00 and nothing else: an editor whose cursor
-- line and floats went transparent too would have no shape left
reset()
ddlc.setup({ transparent = true })
vim.cmd("colorscheme ddlc")
check("the buffer ground goes", hl("Normal").bg == nil, hl("Normal"))
check("the gutter ground goes", hl("LineNr").bg == nil, hl("LineNr"))
check("the sign column ground goes", hl("SignColumn").bg == nil, hl("SignColumn"))
check("the cursor line stays", hex(hl("CursorLine").bg) == dark.base01, hex(hl("CursorLine").bg))
-- Floats are a role of their own: which-key, lspsaga and telescope's preview all link to
-- NormalFloat, so one switch is every one of them. Unset, it follows the buffer
check("floats follow the buffer", hl("NormalFloat").bg == nil, hl("NormalFloat"))
check("the border goes with them", hl("FloatBorder").bg == nil, hl("FloatBorder"))
check("the border still carries a colour", hex(hl("FloatBorder").fg) == dark.base03, hex(hl("FloatBorder").fg))
check("the completion menu is not a float", hex(hl("Pmenu").bg) == dark.base01, hex(hl("Pmenu").bg))

reset()
ddlc.setup({ transparent = true, transparent_floats = false })
vim.cmd("colorscheme ddlc")
check("floats can be kept on a transparent theme", hex(hl("NormalFloat").bg) == dark.base01, hex(hl("NormalFloat").bg))
check("while the buffer is still cleared", hl("Normal").bg == nil, hl("Normal"))

reset()
ddlc.setup({ transparent_floats = true })
vim.cmd("colorscheme ddlc")
check("floats can be cleared on an opaque theme", hl("NormalFloat").bg == nil, hl("NormalFloat"))
check("and the buffer keeps its ground", hex(hl("Normal").bg) == dark.base00, hex(hl("Normal").bg))

reset()
vim.cmd("colorscheme ddlc")
check("opaque by default, floats included", hex(hl("NormalFloat").bg) == dark.base01, hex(hl("NormalFloat").bg))

-- An integration that is off leaves nothing behind, so a plugin the user does not have cannot
-- be styled by accident
reset()
ddlc.setup({ integrations = { telescope = false } })
vim.cmd("colorscheme ddlc")
check("telescope can be turned off", vim.tbl_isempty(hl("TelescopeSelection")), hl("TelescopeSelection"))

reset()
ddlc.setup({ italic_comments = false, overrides = { Normal = { fg = "#FF0000" } } })
vim.cmd("colorscheme ddlc")
check("comments can stay upright", hl("Comment").italic ~= true, hl("Comment"))
check("an override wins", hex(hl("Normal").fg) == "#FF0000", hex(hl("Normal").fg))

-- The light variant, and the two ways of asking for it
reset()
vim.cmd("colorscheme ddlc-light")
check("the light variant names itself", vim.g.colors_name == "ddlc-light", vim.g.colors_name)
check("the light variant moves 'background'", vim.o.background == "light", vim.o.background)
check("the light ground", hex(hl("Normal").bg) == palette.light.base00, hex(hl("Normal").bg))

reset()
vim.o.background = "light"
vim.cmd("colorscheme ddlc")
check("auto follows 'background'", hex(hl("Normal").bg) == palette.light.base00, hex(hl("Normal").bg))

reset()
vim.o.background = "dark"
vim.cmd("colorscheme ddlc")
check("auto follows it back", hex(hl("Normal").bg) == dark.base00, hex(hl("Normal").bg))

local ok = pcall(ddlc.load, "sepia")
check("an unknown variant is an error", not ok)

print(failed == 0 and "all checks passed" or (failed .. " check(s) failed"))
os.exit(failed == 0 and 0 or 1)
