# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versioned by [semver](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

### Added

- `VERSION` at the repo root as the one source of version: the package reads it (it used to say `0.1.0` while the tag said `v1.0.0` — exactly the drift this ends), CI asserts the changelog heading matches

### Changed

- the family CI shape from [huix-standard](https://github.com/rokokol/huix-standard): each linter's one file list lives in the flake's checks (`scripts-lint`, né `shell-is-clean`, and `lua-is-clean`) and the lint job builds those checks instead of repeating the commands; a guard step fails any workflow reaching for unpinned `nix run|shell nixpkgs#…`
- the README follows the `ddlc-terminal-themes` → [`ddlc-themes`](https://github.com/rokokol/ddlc-themes) rename

## [1.0.0] - 2026-08-13

Split out of [rokokol/huix](https://github.com/rokokol/huix), where it was `colorschemes.base16` with a swept transparency pass on top

### Added

- a real lua colorscheme: core groups, treesitter captures, LSP semantic tokens, diagnostics, telescope
- `setup{variant, transparent, transparent_floats, italic_comments, integrations, overrides}`, and `colors/ddlc-{dark,light}.lua` for naming a variant outright
- `doc/ddlc.txt`, so `:help ddlc` answers
- `nixvimModules.ddlc` and `overlays.default`, which puts the plugin under `vimPlugins`
- checks: the suite against the packaged plugin, `palette.lua` current, module wiring, stylua and luacheck
- a weekly `palette-drift.yml` that re-renders against the palette's HEAD rather than the lock
