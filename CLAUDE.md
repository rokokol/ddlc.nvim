# CLAUDE.md

## What this repo is

A real lua colorscheme, not a base16 template: core groups, treesitter captures, LSP semantic tokens, diagnostics and a telescope integration, with `setup{variant, transparent, transparent_floats, italic_comments, integrations, overrides}`. `generate.sh` writes the only two generated files: `lua/ddlc/palette.lua` from the base16 schemes in `ddlc-palette`, and `lua/ddlc/syntax.lua` from `ddlc-themes`' `lib.syntax`, the syntax table every DDLC editor theme shares

The seam in `rokokol/huix` is `home-manager/programs/nixvim/settings.nix`: `imports = [ inputs.ddlc-nvim.nixvimModules.ddlc ]` inside `programs.nixvim`, plus `ddlc.nixvim.{enable,settings}`. The namespace is `ddlc.nixvim` rather than `colorschemes.ddlc` because the upstream nixvim path ends at `vimPlugins.ddlc-nvim` in nixpkgs, which does not exist

## Build / check

```sh
nix build                # the plugin
nix flake check          # tests, palette.lua and syntax.lua current, module wiring, lua-is-clean, scripts-lint
./tests/run.sh           # against DDLC_REPO, so the packaged plugin is what is tested
nix develop -c ./generate.sh    # rewrite lua/ddlc/palette.lua and lua/ddlc/syntax.lua
nix fmt -- --ci
```

`VERSION` is the one source of version: `nix/package.nix` reads it, CI asserts `CHANGELOG.md` has a matching heading

The layout is in the README. `doc/ddlc.txt` is the help, and nixpkgs generates its tags because buildVimPlugin sees a doc dir

Adding an option means three places: the lua default, the README table and `doc/ddlc.txt`. The help is not a copy of the README — it is the same facts in vimdoc form, and `:help ddlc` is what a user inside the editor reaches for

## Changing a colour

It comes from `ddlc-palette` as a base16 scheme, never a literal. What this repo decides is which slot an editor surface takes and which syntax role a code group takes, in `lua/ddlc/`. A syntax colour itself is changed in `ddlc-themes`' `syntax_slots`, never here, because opencode, the Obsidian theme and the reports read the same table. `palette-is-current` fails if either generated file is not what `generate.sh` writes against the locked inputs; the weekly `palette-drift.yml` re-renders against the palette's HEAD instead

## Transparency is a sweep, not a flag

`transparent` clears the grounds painted with base00 over the finished table, because what makes a window opaque is the background colour itself. Do not thread a flag through the group definitions. base01 surfaces (cursor line, selection, completion menu) stay painted on purpose

## Releasing

Every user-visible change adds a bullet under `## [Unreleased]` in `CHANGELOG.md`. A release moves those bullets under a new version heading with the date, tags `v<x.y.z>` and cuts a `gh release` whose notes are that section. Dates belong in this file and nowhere else — the no-dates rule holds everywhere but here, because Keep a Changelog asks for them
