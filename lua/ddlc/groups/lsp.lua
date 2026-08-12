-- Diagnostics and the semantic tokens a language server sends. The tokens only link into the
-- treesitter captures: a server that disagrees with the parser should still look like the file
return function(c, _)
  local levels = {
    Error = c.base08,
    Warn = c.base09,
    Info = c.base0D,
    Hint = c.base0C,
    Ok = c.base0B,
  }

  local groups = {
    LspReferenceText = { bg = c.base02 },
    LspReferenceRead = { bg = c.base02 },
    LspReferenceWrite = { bg = c.base02 },
    LspReferenceTarget = { bg = c.base02 },
    LspSignatureActiveParameter = { fg = c.base0A, bold = true },
    LspInlayHint = { fg = c.base03, bg = c.base01 },
    LspCodeLens = { fg = c.base03 },
    LspCodeLensSeparator = { fg = c.base03 },
    SnippetTabstop = { bg = c.base02 },

    ["@lsp.type.class"] = { link = "@type" },
    ["@lsp.type.decorator"] = { link = "@attribute" },
    ["@lsp.type.enum"] = { link = "@type" },
    ["@lsp.type.enumMember"] = { link = "@constant" },
    ["@lsp.type.function"] = { link = "@function" },
    ["@lsp.type.interface"] = { link = "@type" },
    ["@lsp.type.macro"] = { link = "@function.macro" },
    ["@lsp.type.method"] = { link = "@function.method" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.struct"] = { link = "@type" },
    ["@lsp.type.type"] = { link = "@type" },
    ["@lsp.type.typeParameter"] = { link = "@type.definition" },
    ["@lsp.type.variable"] = { link = "@variable" },
    ["@lsp.mod.deprecated"] = { strikethrough = true },
  }

  for level, colour in pairs(levels) do
    groups["Diagnostic" .. level] = { fg = colour }
    groups["DiagnosticSign" .. level] = { fg = colour }
    groups["DiagnosticFloating" .. level] = { fg = colour }
    groups["DiagnosticVirtualText" .. level] = { fg = colour }
    groups["DiagnosticVirtualLines" .. level] = { fg = colour }
    -- The squiggle carries the level, so the word underneath keeps its syntax colour
    groups["DiagnosticUnderline" .. level] = { sp = colour, undercurl = true }
  end

  groups.DiagnosticDeprecated = { sp = c.base03, strikethrough = true }
  groups.DiagnosticUnnecessary = { fg = c.base03 }

  return groups
end
