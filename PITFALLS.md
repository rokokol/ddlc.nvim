# Pitfalls

Traps around applying this colorscheme that produce plausible but wrong rendering. Each entry names the misleading result, the mechanism and the safe route

## Plugins that copy `Normal` when they set up

**Where it bites:** outside this repository, in the order a Neovim configuration loads the colorscheme and plugin setup. The nixvim module honours the constraint by calling `setup` in `extraConfigLuaPre`, before the `colorscheme` line

**Misleading result:** with `transparent = true`, a tabline stays a solid band across the top of an otherwise transparent editor, or a terminal split stays opaque. It looks as though the theme missed a highlight group

**Mechanism:** a plugin that derives a colour from `Normal` at its own setup keeps whatever it read

- **bufferline** shades its bar out of `Normal.bg`. It has `config.update_highlights()` for re-deriving, but `highlights.set(...)` passes `default = options.themable`, and `nvim_set_hl` with `default = true` will not touch a group that already exists, so a second pass needs `themable = false` as well
- **toggleterm** with `shade_terminals` (its default) darkens the terminal window the same way. A sweep that clears grounds equal to `base00` never reaches it, because a shade of `base00` is not `base00`

A plugin that links to a group instead of copying its colour - which-key and lspsaga link to `NormalFloat` - has no such problem in either order, which is why `transparent_floats` reaches all of them at once and none needs an integration here

**Safe route:** load the colorscheme first. Bufferline then derives from a cleared `Normal`, and toggleterm has nothing to shade

**Reproduction boundary:** inspect the resulting bufferline group

```vim
:lua print(vim.api.nvim_get_hl(0, { name = 'BufferLineFill' }).bg)
```

`nil` means the bar took the transparent ground and the order is right in the active configuration
