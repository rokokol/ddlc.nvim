{
  description = "The Doki Doki Literature Club colorscheme for neovim, light and dark";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ddlc-palette = {
      url = "github:rokokol/ddlc-palette";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # The syntax colours every DDLC editor theme shares
    ddlc-themes = {
      url = "github:rokokol/ddlc-themes";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.ddlc-palette.follows = "ddlc-palette";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ddlc-palette,
      ddlc-themes,
    }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: lib.genAttrs systems (system: f nixpkgs.legacyPackages.${system});

      # Each piece isolated, so a README edit doesn't rebuild anything
      colors = builtins.path {
        name = "ddlc-nvim-colors";
        path = ./colors;
      };
      luaDir = builtins.path {
        name = "ddlc-nvim-lua";
        path = ./lua;
      };
      docDir = builtins.path {
        name = "ddlc-nvim-doc";
        path = ./doc;
      };
      testsDir = builtins.path {
        name = "ddlc-nvim-tests";
        path = ./tests;
      };
      generator = builtins.path {
        name = "generate.sh";
        path = ./generate.sh;
      };

      schemes = ddlc-palette.lib.dist.base16;
      inherit (ddlc-themes.lib) syntax;
    in
    {
      packages = forAllSystems (pkgs: rec {
        default = ddlc-nvim;
        ddlc-nvim = pkgs.callPackage ./nix/package.nix { inherit colors luaDir docDir; };
      });

      # A nixvim module rather than a Home Manager one: the colorscheme belongs inside the
      # editor's configuration, next to the plugins it colours
      nixvimModules.ddlc = import ./nix/module.nix { inherit self; };

      # Under vimPlugins, because that is where every consumer of a neovim plugin looks —
      # programs.neovim.plugins and home.packages both take it from there
      overlays.default = final: prev: {
        vimPlugins = prev.vimPlugins // {
          inherit (self.packages.${final.stdenv.hostPlatform.system}) ddlc-nvim;
        };
      };

      checks = forAllSystems (
        pkgs:
        let
          plugin = self.packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          # Against the built plugin, not the checkout, so the packaging is under test too
          tests =
            pkgs.runCommand "tests"
              {
                nativeBuildInputs = with pkgs; [
                  bash
                  neovim
                ];
              }
              ''
                export DDLC_REPO=${plugin}
                bash ${testsDir}/run.sh
                touch $out
              '';

          # The palette and syntax tables are generated and committed, so a clone without Nix
          # still has the colours; this proves they are what the generator writes against the
          # locked palette and syntax table
          palette-is-current = pkgs.runCommand "palette-is-current" { } ''
            mkdir -p lua/ddlc
            install -m755 ${generator} generate.sh
            DDLC_BASE16_LIGHT=${schemes.light} DDLC_BASE16_DARK=${schemes.dark} \
              DDLC_SYNTAX=${syntax} bash generate.sh >/dev/null
            diff ${luaDir}/ddlc/palette.lua lua/ddlc/palette.lua
            diff ${luaDir}/ddlc/syntax.lua lua/ddlc/syntax.lua
            touch $out
          '';

          # Enabling the module has to be enough: the plugin installed, the colorscheme named
          # and the settings handed to setup — and nothing at all while it is disabled
          module-wiring =
            let
              wiring = import ./nix/module-test.nix {
                inherit lib pkgs;
                module = self.nixvimModules.ddlc;
              };
            in
            pkgs.runCommand "module-wiring"
              {
                nativeBuildInputs = with pkgs; [ jq ];
                dump = builtins.toJSON wiring;
                passAsFile = [ "dump" ];
              }
              ''
                want() { jq -e "$1" "$dumpPath" >/dev/null || { echo "module wiring: $2"; exit 1; }; }

                want '.plugins | index("ddlc.nvim")' "the plugin is not installed"
                want '.colorscheme == "ddlc"' "the colorscheme is not named"
                want '.setup | test("require\\(\"ddlc\"\\).setup")' "setup is not called"
                # A setting has to reach setup unchanged — the lua defaults are the only defaults
                want '.setup | test("light")' "a setting does not reach setup"

                want '.offPlugins == []' "the plugin is installed while disabled"
                want '.offColorscheme == null' "the colorscheme is named while disabled"
                want '.offSetup == ""' "setup is called while disabled"
                touch $out
              '';

          lua-is-clean =
            pkgs.runCommand "lua-is-clean"
              {
                nativeBuildInputs = with pkgs; [
                  stylua
                  luajitPackages.luacheck
                ];
              }
              ''
                cp -r ${colors} colors
                cp -r ${luaDir} lua
                cp ${./.luacheckrc} .luacheckrc
                cp ${./.stylua.toml} .stylua.toml
                stylua --check colors lua
                luacheck colors lua
                touch $out
              '';

          # The one shell file list lives here and nowhere else: CI's lint job is a fast
          # named status for this check and lua-is-clean, not a second copy of the commands
          scripts-lint =
            pkgs.runCommand "scripts-lint"
              {
                nativeBuildInputs = with pkgs; [
                  shellcheck
                  shfmt
                ];
              }
              ''
                files="${generator} ${testsDir}/run.sh"
                # shellcheck disable=SC2086
                shellcheck $files
                # shellcheck disable=SC2086
                shfmt -i 2 -ci -d $files
                touch $out
              '';
        }
      );

      devShells = forAllSystems (pkgs: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            neovim
            stylua
            luajitPackages.luacheck
            shellcheck
            shfmt
          ];
          # So generate.sh runs with no arguments inside the shell
          DDLC_BASE16_LIGHT = schemes.light;
          DDLC_BASE16_DARK = schemes.dark;
          DDLC_SYNTAX = syntax;
        };
      });

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);
    };
}
