# Deviations

Choices that make this a real colorscheme rather than a base16 template. Each entry says where the theme departs from the generic route, why and what the generic route would break. An arrangement that an upstream change could retire belongs in a `WORKAROUNDS.md` instead

---

## Telescope groups are named outright

**Where:** `lua/ddlc/groups/telescope.lua` - every telescope group is named outright rather than left to the scheme

**Why it differs from the obvious route:** base16-nvim means to give telescope grounds of its own, one shade off the rest, and reaches for

```lua
local darkerbg = darken(M.colors.base00, 0.1)
```

but `darken` does not darken - it blends its argument towards `base00`, which is right for its seven other callers (`darken(base0B, 0.85)` is how the diff-add background is arrived at) and an identity for this one: `r + (r - r) * pct == r`, for every scheme and every `pct`. So `TelescopeNormal`, `TelescopeBorder` and `TelescopeResultsTitle` land on the ordinary background, while `TelescopePromptNormal` and `TelescopeSelection`, built from `base02`, do move. On stock `base16-default-dark` that reads `#181818` against `#343434`. The defect is reported as [RRethy/base16-nvim#120](https://github.com/RRethy/base16-nvim/issues/120), with a fix in [#121](https://github.com/RRethy/base16-nvim/pull/121). The fix would make a base16 template a usable fallback again, but it would not remove this integration: the panes having no ground of their own is the design

**What returning to the obvious route breaks:** the picker renders as a hole. A terminal at less than full opacity draws the results and preview panes transparent, showing the wallpaper, while the prompt sits on top of them as a solid slab, and no border separates any of it

---

## Transparency is an option on the finished theme

**Where:** `lua/ddlc/init.lua` - the `transparent` option is applied to the theme's table before any group is set

**Why it differs from the obvious route:** gruvbox has `transparent_mode`, which nils `bg` on `Normal`, `NormalFloat`, `WinSeparator`, `SignColumn`, `FoldColumn` and the sign groups; base16-nvim has no equivalent, and a template rendering a scheme cannot add one. The only way through from outside is to clear the grounds after the scheme has been applied, after every plugin has already read the colours it wanted. Owning this option and applying it before groups are set is why the theme is a plugin

**What returning to the obvious route breaks:** a terminal running at less than full opacity shows through nowhere, because every ground is painted

**Rejected alternative:** a base16 template plus a late sweep. It leaves plugins that copied `Normal` at setup time with stale opaque colours; [PITFALLS.md](PITFALLS.md) carries that load-order trap
