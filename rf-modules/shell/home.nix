{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.hm-modules.shell;
in {
  imports = [
    ./direnv/home.nix
    ./zsh/home.nix
  ];

  options.hm-modules.shell = {
    fzf = mkOption { type = types.submodule {
      options = {
        enable = mkEnableOption false;
      };
    }; };
    ranger = mkOption { type = types.submodule {
      options = {
        enable = mkEnableOption false;
      };
    }; };
  };

  config = (mkMerge [
    (mkIf cfg.fzf.enable {
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    })

    (mkIf cfg.ranger.enable {
      home.file = {
        ".config/ranger/rc.conf".source =     ../../modules/shell/ranger/rc.conf;
        ".config/ranger/rifle.conf".source =  ../../modules/shell/ranger/rifle.conf;
        ".config/ranger/commands.py".source = ../../modules/shell/ranger/commands.py;
        ".config/ranger/scope.sh".source =    ../../modules/shell/ranger/scope.sh;
      };
      home.packages = with pkgs; [ ranger pfetch ];
    })
  ]);
}