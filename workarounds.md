# Workarounds

Defects elsewhere that this theme is shaped by. Each entry says where it bites, why it happens and what would retire it. The first two are why a colorscheme exists here at all instead of a base16 template — they were carried in [huix/workarounds.md](https://github.com/rokokol/huix/blob/master/workarounds.md) for as long as the editor was themed with [base16-nvim](https://github.com/RRethy/base16-nvim), against these same colours

---

## `darken(base00, pct)` hands `base00` back

**Where:** `lua/ddlc/groups/telescope.lua` — every telescope group is named outright rather than left to the scheme

**Symptom it prevents:** the picker renders as a hole. The results and preview panes show the wallpaper while the prompt sits on top of them as a solid slab, and no border separates any of it

**Why it happens:** base16-nvim means to give telescope grounds of its own, one shade off the rest, and reaches for

```lua
local darkerbg = darken(M.colors.base00, 0.1)
```

but `darken` does not darken — it blends its argument towards `base00`, which is right for its seven other callers (`darken(base0B, 0.85)` is how the diff-add background is arrived at) and an identity for this one: `r + (r - r) * pct == r`, for every scheme and every `pct`. So `TelescopeNormal`, `TelescopeBorder` and `TelescopeResultsTitle` land on the ordinary background, while `TelescopePromptNormal` and `TelescopeSelection`, built from `base02`, do move. On stock `base16-default-dark` that reads `#181818` against `#343434`. A terminal at less than full opacity then draws the results pane transparent under an opaque prompt

**Reported:** [RRethy/base16-nvim#120](https://github.com/RRethy/base16-nvim/issues/120), fix in [#121](https://github.com/RRethy/base16-nvim/pull/121) — both open

**Removal check:**

```sh
# the one call whose target is the colour it is being blended into
curl -s https://raw.githubusercontent.com/RRethy/base16-nvim/master/lua/base16-colorscheme.lua |
  grep -n 'darken(M.colors.base00'
```

No match → the call takes a real target now. It changes nothing here — the integration is a design of its own, with no ground on the panes — but a base16 template becomes a usable fallback again

---

## A base16 scheme has no transparency switch

**Where:** `lua/ddlc/init.lua` — the `transparent` option, applied to the theme's table before any group is set

**Symptom it prevents:** a terminal running at less than full opacity shows through nowhere, because every ground is painted

**Why it happens:** gruvbox has `transparent_mode`, which nils `bg` on `Normal`, `NormalFloat`, `WinSeparator`, `SignColumn`, `FoldColumn` and the sign groups; base16-nvim has no equivalent, and a template rendering a scheme cannot add one. The only way through from outside is to clear the grounds *after* the scheme has been applied — which is a sweep at the end of `init.lua`, and that lands after every plugin has already read the colours it wanted (see below)

**Removal check:** none. This is why the theme is a plugin

---

## Plugins that copy `Normal` when they set up

**Where:** nothing in this repository — it is a rule about load order, and the nixvim module honours it by calling `setup` in `extraConfigLuaPre`, before the `colorscheme` line

**Symptom it prevents:** with `transparent = true`, a tabline that stays a solid band across the top of an otherwise transparent editor, or a terminal split that stays opaque

**Why it happens:** a plugin that derives a colour from `Normal` at its own setup keeps whatever it read:

- **bufferline** shades its bar out of `Normal.bg`. It has `config.update_highlights()` for re-deriving, but `highlights.set(...)` passes `default = options.themable`, and `nvim_set_hl` with `default = true` will not touch a group that already exists — so a second pass needs `themable = false` as well
- **toggleterm** with `shade_terminals` (its default) darkens the terminal window the same way. A sweep that clears grounds equal to `base00` never reaches it, because a shade of `base00` is not `base00`

Load the colorscheme first and neither has anything stale to keep: bufferline derives from a cleared `Normal`, and toggleterm has nothing to shade

A plugin that *links* to a group instead of copying its colour — which-key and lspsaga link to `NormalFloat` — has no such problem in either order, which is why `transparent_floats` reaches all of them at once and none of them needs an integration here

**Removal check:**

```vim
:lua print(vim.api.nvim_get_hl(0, { name = 'BufferLineFill' }).bg)
```

`nil` → the bar took the transparent ground, so the order is right in your configuration
