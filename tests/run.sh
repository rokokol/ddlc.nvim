#!/usr/bin/env bash
# The theme against a headless neovim. tests/assert.lua does the checking; this only isolates
set -euo pipefail

usage() {
  cat <<'EOF'
tests/run.sh — the fast suite for ddlc.nvim: runs tests/assert.lua against a headless
neovim, isolated from any live session's state

  tests/run.sh

NVIM picks the binary (default: nvim on PATH); DDLC_REPO picks the checkout tested
(default: the one this script lives in)

Nothing here reaches the network
Exit: 0 all passed, 1 a check failed
EOF
}
[[ "${1:-}" == "-h" || "${1:-}" == "--help" || "${1:-}" == "help" ]] && {
  usage
  exit 0
}

here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
nvim="${NVIM:-nvim}"

# A live session writes into these, and a run that shares them is testing that session too
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp"
export XDG_DATA_HOME="$tmp/data"
export XDG_STATE_HOME="$tmp/state"
export XDG_CACHE_HOME="$tmp/cache"
export DDLC_REPO="${DDLC_REPO:-$(dirname "$here")}"

# The checkout goes in front of the runtimepath, not behind it: with -u NONE there is nothing
# else to shadow it here, but a packaged copy would win in any real session
"$nvim" --headless -u NONE -i NONE -l "$here/assert.lua"
