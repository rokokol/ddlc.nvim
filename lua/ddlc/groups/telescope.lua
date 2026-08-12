-- No ground of its own: the pane is whatever the window behind it is, and the frame carries the
-- shape. Painting the panes instead sinks them into a slab, which under a translucent terminal
-- reads as a hole with a bar floating over it
return function(c, _)
  local pane = { fg = c.base05 }
  local frame = { fg = c.base04 }

  return {
    TelescopeNormal = pane,
    TelescopeResultsNormal = pane,
    TelescopePreviewNormal = pane,
    TelescopePromptNormal = pane,

    TelescopeBorder = frame,
    TelescopeResultsBorder = frame,
    TelescopePreviewBorder = frame,
    TelescopePromptBorder = frame,

    TelescopeTitle = { fg = c.base04 },
    TelescopeResultsTitle = { fg = c.base04 },
    TelescopePreviewTitle = { fg = c.base0B },
    TelescopePromptTitle = { fg = c.base0E },
    TelescopePromptPrefix = { fg = c.base0E },
    TelescopePromptCounter = { fg = c.base03 },

    TelescopeSelection = { bg = c.base02 },
    TelescopeSelectionCaret = { fg = c.base0E },
    TelescopeMultiSelection = { fg = c.base03 },
    TelescopeMultiIcon = { fg = c.base0E },
    TelescopeMatching = { fg = c.base0A },
    TelescopePreviewLine = { bg = c.base01 },
  }
end
