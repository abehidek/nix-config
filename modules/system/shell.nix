{ config, lib, pkgs, ... }:

with lib;
let 
  cfg = config.modules.system.shell;
in {
  options.modules.system.shell = {
    nushell = {
      enable = mkEnableOption "Enables nushell on system";
      defaultShellUsers = mkOption { type = types.listOf (types.str); };
    };
    zsh = {
      enable = mkEnableOption "Enables zsh";
      defaultShellUsers = mkOption { type = types.listOf (types.str); };
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
    forAllZshUsers = for (cfg.zsh.defaultShellUsers);
    forAllDirenvUsers = for (cfg.direnv.users);
  in (mkMerge [
    (mkIf cfg.nushell.enable (mkMerge [
      {
        environment.systemPackages = with pkgs; [ nushell ];
        environment.shells = [
          "/run/current-system/sw/bin/nu"
          "${pkgs.nushell}/bin/nu"
        ];
        users.users = (for cfg.nushell.defaultShellUsers) (user: {
          shell = pkgs.nushell;
        });
      }
    ]))
    (mkIf cfg.zsh.enable (mkMerge [
      {
        programs.zsh.enable = true;
        environment.systemPackages = with pkgs; [ zsh ];
        environment.shells = with pkgs; [ zsh ];

        users.users = forAllZshUsers (user: {
          shell = pkgs.zsh;
        });
      }
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