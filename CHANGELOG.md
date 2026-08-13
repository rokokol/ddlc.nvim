# Changelog

Kept in the shape of [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), versioned by [semver](https://semver.org/spec/v2.0.0.html)

## [Unreleased]

## [1.0.0] - 2026-08-13

Split out of [rokokol/huix](https://github.com/rokokol/huix), where it was `colorschemes.base16` with a swept transparency pass on top

### Added

- a real lua colorscheme: core groups, treesitter captures, LSP semantic tokens, diagnostics, telescope
- `setup{variant, transparent, transparent_floats, italic_comments, integrations, overrides}`, and `colors/ddlc-{dark,light}.lua` for naming a variant outright
- `doc/ddlc.txt`, so `:help ddlc` answers
- `nixvimModules.ddlc` and `overlays.default`, which puts the plugin under `vimPlugins`
- checks: the suite against the packaged plugin, `palette.lua` current, module wiring, stylua and luacheck
- a weekly `palette-drift.yml` that re-renders against the palette's HEAD rather than the lock
