{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.ddlc.nixvim;
in
{
  options.ddlc.nixvim = {
    enable = lib.mkEnableOption "the DDLC colorscheme";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
      defaultText = lib.literalExpression "ddlc-nvim.packages.\${system}.default";
      description = "The plugin to install";
    };

    settings = lib.mkOption {
      type = with lib.types; attrsOf anything;
      default = { };
      example = {
        variant = "dark";
        transparent = true;
        integrations.telescope = false;
      };
      description = ''
        Handed to `require('ddlc').setup` unchanged. The lua defaults are the only
        defaults — this module keeps none of its own to fall out of step with them
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    extraPlugins = [ cfg.package ];
    colorscheme = "ddlc";
    # Pre, because nixvim emits `colorscheme` as vimscript after this block, and the theme has
    # to know its options by the time the colours are laid down
    extraConfigLuaPre = ''
      require("ddlc").setup(${lib.nixvim.toLuaObject cfg.settings})
    '';
  };
}
