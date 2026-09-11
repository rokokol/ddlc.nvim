# Deviations

Choices that make this a real colorscheme rather than a base16 template. Each entry says where the theme departs from the generic route, what forced the choice and what would make it worth reconsidering

---

## Telescope groups are named outright

**Where:** `lua/ddlc/groups/telescope.lua` - every telescope group is named outright rather than left to the scheme

**What it prevents:** the picker renders as a hole. The results and preview panes show the wallpaper while the prompt sits on top of them as a solid slab, and no border separates any of it

**Why:** base16-nvim means to give telescope grounds of its own, one shade off the rest, and reaches for

```lua
local darkerbg = darken(M.colors.base00, 0.1)
```

but `darken` does not darken - it blends its argument towards `base00`, which is right for its seven other callers (`darken(base0B, 0.85)` is how the diff-add background is arrived at) and an identity for this one: `r + (r - r) * pct == r`, for every scheme and every `pct`. So `TelescopeNormal`, `TelescopeBorder` and `TelescopeResultsTitle` land on the ordinary background, while `TelescopePromptNormal` and `TelescopeSelection`, built from `base02`, do move. On stock `base16-default-dark` that reads `#181818` against `#343434`. A terminal at less than full opacity then draws the results pane transparent under an opaque prompt

**Reported:** [RRethy/base16-nvim#120](https://github.com/RRethy/base16-nvim/issues/120), fix in [#121](https://github.com/RRethy/base16-nvim/pull/121) - both open

**Reconsidered by:** the upstream call taking a real target, which this check reveals when it stops matching

```sh
curl -s https://raw.githubusercontent.com/RRethy/base16-nvim/master/lua/base16-colorscheme.lua |
  grep -n 'darken(M.colors.base00'
```

The fix would make a base16 template a usable fallback again, but it would not by itself remove this integration: the panes having no ground of their own is now the design

---

## Transparency is an option on the finished theme

**Where:** `lua/ddlc/init.lua` - the `transparent` option is applied to the theme's table before any group is set

**What it prevents:** a terminal running at less than full opacity shows through nowhere, because every ground is painted

**Why:** gruvbox has `transparent_mode`, which nils `bg` on `Normal`, `NormalFloat`, `WinSeparator`, `SignColumn`, `FoldColumn` and the sign groups; base16-nvim has no equivalent, and a template rendering a scheme cannot add one. The only way through from outside is to clear the grounds after the scheme has been applied, after every plugin has already read the colours it wanted

**Rejected alternative:** a base16 template plus a late sweep. It leaves plugins that copied `Normal` at setup time with stale opaque colours; [PITFALLS.md](PITFALLS.md) carries that load-order trap

**Reconsidered by:** nothing. Owning this option and applying it before groups are set is why the theme is a plugin
