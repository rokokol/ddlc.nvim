# Evaluates the nixvim module against stubs of the three options it writes to, so the wiring is
# checked without a neovim build. What it cannot check is the option names themselves — those
# come from nixvim, and a real configuration is what proves them
{
  lib,
  pkgs,
  module,
}:

let
  # The parts of nixvim's own lib the module reaches for. Serialising a table is nixvim's job;
  # here it only has to be recognisable in the output
  nixvimLib = lib // {
    nixvim.toLuaObject = lib.generators.toPretty { multiline = false; };
  };

  stubs = {
    options = {
      extraPlugins = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
      };
      colorscheme = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };
      extraConfigLuaPre = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };
    };
  };

  eval =
    settings:
    (lib.evalModules {
      modules = [
        stubs
        module
        settings
      ];
      specialArgs = {
        inherit pkgs;
        lib = nixvimLib;
      };
    }).config;

  on = eval {
    ddlc.nixvim = {
      enable = true;
      settings = {
        variant = "light";
        transparent = true;
      };
    };
  };
  off = eval { };
in
{
  plugins = map (p: p.pname or p.name) on.extraPlugins;
  colorscheme = on.colorscheme;
  setup = on.extraConfigLuaPre;

  offPlugins = off.extraPlugins;
  offColorscheme = off.colorscheme;
  offSetup = off.extraConfigLuaPre;
}
