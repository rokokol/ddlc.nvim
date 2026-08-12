local M = {}

M.defaults = {
  -- "auto" reads vim.o.background, which is what :set background=light already moves
  variant = "auto",
  -- Clears the grounds painted with base00 and nothing else: a cursor line and a float sit on
  -- base01, and clearing those too would leave the editor with no shape at all
  transparent = false,
  italic_comments = true,
  integrations = {
    telescope = true,
  },
  -- Highlight groups merged last, so a single group can be moved without forking the theme
  overrides = {},
}

M.config = vim.deepcopy(M.defaults)

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
  return M.config
end

-- Slot for slot the table a terminal gets, so :terminal agrees with the buffer around it
local ansi = {
  "base00",
  "base08",
  "base0B",
  "base0A",
  "base0D",
  "base0E",
  "base0C",
  "base05",
  "base02",
  "base08",
  "base0B",
  "base0A",
  "base0D",
  "base0E",
  "base0C",
  "base07",
}

local function resolve(variant)
  if variant == "auto" then
    return vim.o.background == "light" and "light" or "dark"
  end
  return variant
end

function M.groups(variant, config)
  local cfg = config or M.config
  local name = resolve(variant or cfg.variant)
  local c = require("ddlc.palette")[name]
  if not c then
    error("ddlc: no such variant: " .. tostring(name))
  end

  local groups = {}
  local function merge(t)
    for group, spec in pairs(t) do
      groups[group] = spec
    end
  end

  merge(require("ddlc.groups.core")(c, cfg))
  merge(require("ddlc.groups.treesitter")(c, cfg))
  merge(require("ddlc.groups.lsp")(c, cfg))
  for integration, on in pairs(cfg.integrations) do
    if on then
      merge(require("ddlc.groups." .. integration)(c, cfg))
    end
  end
  merge(cfg.overrides)

  -- One sweep rather than a flag threaded through every table: what makes a window opaque is
  -- the background colour itself, so that is what the option is about
  if cfg.transparent then
    for group, spec in pairs(groups) do
      if spec.bg == c.base00 then
        local cleared = vim.deepcopy(spec)
        cleared.bg = nil
        groups[group] = cleared
      end
    end
  end

  return groups, c, name
end

function M.load(variant)
  local name = resolve(variant or M.config.variant)

  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  -- Guarded: neovim re-sources the colorscheme when 'background' moves, and this is called from
  -- exactly that file
  if vim.o.background ~= name then
    vim.o.background = name
  end
  vim.g.colors_name = "ddlc"

  local groups, c = M.groups(name)

  for group, spec in pairs(groups) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  for i, slot in ipairs(ansi) do
    vim.g["terminal_color_" .. (i - 1)] = c[slot]
  end
end

return M
