{
  lib,
  runCommand,
  vimUtils,
  colors,
  luaDir,
  docDir,
}:

vimUtils.buildVimPlugin {
  pname = "ddlc.nvim";
  version = "0.1.0";

  # Assembled rather than taken from the repository root, so a README or a workflow edit does
  # not rebuild the plugin
  src = runCommand "ddlc-nvim-source" { } ''
    mkdir -p $out
    cp -r ${colors} $out/colors
    cp -r ${luaDir} $out/lua
    cp -r ${docDir} $out/doc
  '';

  meta = {
    description = "The Doki Doki Literature Club colorscheme for neovim";
    homepage = "https://github.com/rokokol/ddlc.nvim";
    # MIT covers the theme; the colours themselves are Team Salvato's
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
  };
}
