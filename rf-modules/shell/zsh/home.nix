{ lib, config, pkgs, ... }:
with lib;
let cfg = config.hm-modules.shell.zsh;
in {
  imports = [];

  options.hm-modules.shell.zsh = {
    historySize = mkOption { type = types.int; };
    nixShellCompat = mkEnableOption "Enable nix-shell compatibility";
    powerlevel10k = mkOption { type = types.submodule {
      options = {
        enable = mkEnableOption "Enables powerlevel10k";
        riceFolder = mkOption { type = types.path; };
        instantPrompt = mkEnableOption "Enables Instant Prompt on powerlevel10k";
      };
    };};
    oh-my-zsh = mkOption { type = types.submodule {
      options = {
        enable = mkEnableOption "Enables oh-my-zsh";
        plugins = mkOption { type = types.listOf (types.str); };
      };
    };};
  };

  config = (mkMerge [
    {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        history = {
          size = cfg.historySize;
          path = "$HOME/.local/share/zsh/history";
        };
        zplug = {
          enable = true;
          plugins = [
            { name = "zsh-users/zsh-autosuggestions"; }
            { name = "supercrabtree/k"; }
          ];
        };
      };
    }
    (mkIf cfg.nixShellCompat{
      programs.zsh.initExtraFirst = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
      '';
    })
    (mkIf cfg.powerlevel10k.enable (mkMerge[
      {
        programs.zsh.plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
          {
            name = "powerlevel10k-config";
            src = lib.cleanSource cfg.powerlevel10k.riceFolder;
            file = "config.zsh";
          }
        ];
      }
      (mkIf cfg.powerlevel10k.instantPrompt{
        programs.zsh.initExtraFirst = ''
          P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
          [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
        '';
      })
    ]))
    (mkIf cfg.oh-my-zsh.enable {
      programs.zsh.oh-my-zsh = {
        enable = true;
        plugins = cfg.oh-my-zsh.plugins;
      };
    })
  ]);
}
