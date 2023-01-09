{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.modules.system.shell;
in {
  options.modules.system.shell = {
    zsh = {
      enable = mkEnableOption "Enables zsh";
      users = mkOption { type = types.listOf (types.str); };
      rice = mkEnableOption "Enables zsh home-manager rice";
    };
    tmux = {
      enable = mkEnableOption "Enables tmux";
    };
    direnv = {
      enable = mkEnableOption "Enables direnv";
      users = mkOption { type = types.listOf (types.str); };
    };
  };

  config = 
  let
    for = x: genAttrs (x);
    forAllZshUsers = for (cfg.zsh.users);
    forAllDirenvUsers = for (cfg.direnv.users);
  in (mkMerge [
    (mkIf cfg.zsh.enable (mkMerge [
      {
        programs.zsh.enable = true;
        environment.systemPackages = with pkgs; [ zsh ];
        environment.shells = with pkgs; [ zsh ];

        users.users = forAllZshUsers (user: {
          shell = pkgs.zsh;
        });
      }
      (mkIf cfg.zsh.rice{
        home-manager.users = forAllZshUsers (user: {
          programs.zsh = {
            enable = true;
            enableCompletion = true;
            enableSyntaxHighlighting = true;
            history = {
              size = 5000;
              path = "$HOME/.local/share/zsh/history";
            };
            zplug = {
              enable = true;
              plugins = [
                { name = "zsh-users/zsh-autosuggestions"; }
                { name = "supercrabtree/k"; }
              ];
            };
            initExtraFirst = ''
              ${pkgs.any-nix-shell}/bin/any-nix-shell zsh --info-right | source /dev/stdin
            '';
            oh-my-zsh = {
              enable = true;
              plugins = [ "git" "web-search" "copypath" "dirhistory" ];
            };
          };
        });
      })
    ]))
    (mkIf cfg.tmux.enable {
      environment.systemPackages = with pkgs; [ tmux ];
    })
    (mkIf cfg.direnv.enable {
      environment.systemPackages = with pkgs; [ direnv nix-direnv ];
      nix.extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';

      home-manager.users = forAllDirenvUsers (user: {
        programs.direnv.enable = true;
        programs.direnv.nix-direnv.enable = true;
      });
    })
  ]);
}