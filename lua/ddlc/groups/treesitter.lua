-- The @-captures, as neovim 0.10 spells them. Only the ones that depart from the legacy group
-- they already fall back to are listed — a capture that wants Comment simply keeps it
return function(c, cfg)
  return {
    -- Text
    ["@variable"] = { fg = c.base05 },
    ["@variable.builtin"] = { fg = c.base08 },
    ["@variable.parameter"] = { fg = c.base08 },
    ["@variable.member"] = { fg = c.base05 },
    ["@property"] = { fg = c.base05 },
    ["@field"] = { fg = c.base05 },

    -- Literals
    ["@string.regexp"] = { fg = c.base0C },
    ["@string.escape"] = { fg = c.base0F },
    ["@string.special"] = { fg = c.base0F },
    ["@character.special"] = { fg = c.base0F },

    -- Callables
    ["@function"] = { fg = c.base0D },
    ["@function.builtin"] = { fg = c.base0D },
    ["@function.method"] = { fg = c.base0D },
    ["@function.macro"] = { fg = c.base08 },
    ["@constructor"] = { fg = c.base0A },

    -- Keywords, which the palette spends its magenta on
    ["@keyword"] = { fg = c.base0E },
    ["@keyword.function"] = { fg = c.base0E },
    ["@keyword.operator"] = { fg = c.base0E },
    ["@keyword.return"] = { fg = c.base0E },
    ["@keyword.import"] = { fg = c.base0D },
    ["@keyword.exception"] = { fg = c.base08 },
    ["@keyword.directive"] = { fg = c.base0A },

    -- Types and modules
    ["@type"] = { fg = c.base0A },
    ["@type.builtin"] = { fg = c.base0A },
    ["@type.definition"] = { fg = c.base0A },
    ["@attribute"] = { fg = c.base0A },
    ["@module"] = { fg = c.base0A },
    ["@label"] = { fg = c.base0A },

    -- Punctuation: the brackets stay text, only what separates gets a colour
    ["@operator"] = { fg = c.base05 },
    ["@punctuation.bracket"] = { fg = c.base05 },
    ["@punctuation.delimiter"] = { fg = c.base0F },
    ["@punctuation.special"] = { fg = c.base0F },

    -- Comments beyond the plain one
    ["@comment.error"] = { fg = c.base08 },
    ["@comment.warning"] = { fg = c.base09 },
    ["@comment.note"] = { fg = c.base0C },
    ["@comment.todo"] = { link = "Todo" },

    -- Markup, which is most of what a notes vault renders as
    ["@markup.heading"] = { fg = c.base0D, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.link"] = { fg = c.base0D },
    ["@markup.link.url"] = { fg = c.base0C, underline = true },
    ["@markup.link.label"] = { fg = c.base0E },
    ["@markup.raw"] = { fg = c.base0B },
    ["@markup.list"] = { fg = c.base0E },
    ["@markup.quote"] = { fg = c.base03, italic = cfg.italic_comments },
    ["@markup.math"] = { fg = c.base0C },

    -- Tags, which is HTML and JSX
    ["@tag"] = { fg = c.base0A },
    ["@tag.builtin"] = { fg = c.base0A },
    ["@tag.attribute"] = { fg = c.base0D },
    ["@tag.delimiter"] = { fg = c.base0F },

    ["@diff.plus"] = { fg = c.base0B },
    ["@diff.minus"] = { fg = c.base08 },
    ["@diff.delta"] = { fg = c.base0D },
  }
end
