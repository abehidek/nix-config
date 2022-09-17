{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = utils.mkBoolOpt false;
    defaultShellUsers = mkOption {
      type = types.listOf (types.str);
    };
  };

  config = let forAllUsers = lib.genAttrs (cfg.defaultShellUsers); in mkIf cfg.enable (mkMerge [
    {
      programs.zsh.enable = true;
      environment.shells = with pkgs; [ zsh ];
      users.users = forAllUsers (user: let 
        shell = self."${user}".shell;
        in {
          shell = pkgs.zsh;
        }
      );
    }
  ]);
}
