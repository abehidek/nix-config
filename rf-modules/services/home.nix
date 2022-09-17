{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.hm-modules.services;
in {
  imports = [
  ];

  options.hm-modules.services = {
    git = mkOption { type = types.submodule {
      options = {
        enable = mkEnableOption false;
        defaultBranch = mkOption { type = types.str; };
      };
    }; };
    gpg = mkOption { type = types.submodule {
      options = {
        enable = mkEnableOption false;
      };
    }; };
  };

  config = (mkMerge [
    (mkIf cfg.git.enable {
      programs = {
        git = {
          enable = true;
          userName = "abehidek";
          userEmail = "hidek.abe@outlook.com";
          extraConfig = { init = { defaultBranch = cfg.git.defaultBranch; }; };
        };
      };
    })
    (mkIf cfg.gpg.enable {
      programs = {
        gpg = { enable = true; };
      };
    })
  ]);
}