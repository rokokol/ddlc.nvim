-- The @-captures, as neovim 0.10 spells them. Only the ones that depart from the legacy group
-- they already fall back to are listed — a capture that wants Comment simply keeps it.
-- Code takes the shared syntax table; the levels of a comment and of a diff stay on the
-- base16 slots the diagnostics use, so a marker reads the same in the gutter and in the text
return function(c, cfg, s)
  return {
    -- Text
    ["@variable"] = { fg = s.text },
    ["@variable.builtin"] = { fg = s.builtin },
    ["@variable.parameter"] = { fg = s.builtin },
    ["@variable.member"] = { fg = s.text },
    ["@property"] = { fg = s.text },
    ["@field"] = { fg = s.text },

    -- Literals
    ["@string.regexp"] = { fg = s.special },
    ["@string.escape"] = { fg = s.delimiter },
    ["@string.special"] = { fg = s.delimiter },
    ["@character.special"] = { fg = s.delimiter },

    -- Callables
    ["@function"] = { fg = s["function"] },
    ["@function.builtin"] = { fg = s["function"] },
    ["@function.method"] = { fg = s["function"] },
    ["@function.macro"] = { fg = s.builtin },
    ["@constructor"] = { fg = s.type },

    -- Keywords, which the palette spends its magenta on
    ["@keyword"] = { fg = s.keyword },
    ["@keyword.function"] = { fg = s.keyword },
    ["@keyword.operator"] = { fg = s.keyword },
    ["@keyword.return"] = { fg = s.keyword },
    ["@keyword.import"] = { fg = s["function"] },
    ["@keyword.exception"] = { fg = s.builtin },
    ["@keyword.directive"] = { fg = s.type },

    -- Types and modules
    ["@type"] = { fg = s.type },
    ["@type.builtin"] = { fg = s.type },
    ["@type.definition"] = { fg = s.type },
    ["@attribute"] = { fg = s.type },
    ["@module"] = { fg = s.type },
    ["@label"] = { fg = s.type },

    -- Punctuation: the brackets stay text, only what separates gets a colour
    ["@operator"] = { fg = s.text },
    ["@punctuation.bracket"] = { fg = s.text },
    ["@punctuation.delimiter"] = { fg = s.delimiter },
    ["@punctuation.special"] = { fg = s.delimiter },

    -- Comments beyond the plain one
    ["@comment.error"] = { fg = c.base08 },
    ["@comment.warning"] = { fg = c.base09 },
    ["@comment.note"] = { fg = c.base0C },
    ["@comment.todo"] = { link = "Todo" },

    -- Markup, which is most of what a notes vault renders as
    ["@markup.heading"] = { fg = s.heading, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.link"] = { fg = s.link },
    ["@markup.link.url"] = { fg = s.url, underline = true },
    ["@markup.link.label"] = { fg = s["link-label"] },
    ["@markup.raw"] = { fg = s.raw },
    ["@markup.list"] = { fg = s.list },
    ["@markup.quote"] = { fg = s.quote, italic = cfg.italic_comments },
    ["@markup.math"] = { fg = s.special },

    -- Tags, which is HTML and JSX
    ["@tag"] = { fg = s.type },
    ["@tag.builtin"] = { fg = s.type },
    ["@tag.attribute"] = { fg = s["function"] },
    ["@tag.delimiter"] = { fg = s.delimiter },

    ["@diff.plus"] = { fg = c.base0B },
    ["@diff.minus"] = { fg = c.base08 },
    ["@diff.delta"] = { fg = c.base0D },
  }
end
