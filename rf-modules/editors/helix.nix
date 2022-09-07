{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.hm-modules.editors.helix;
in {
  imports = [
  ];

  options.hm-modules.editors.helix = {
    enable = mkEnableOption false;
  };

  config = (mkMerge [
    (mkIf cfg.enable {
      programs.helix = {
        enable = true;
        languages = [
          { name = "rust"; auto-format = true; }
        ];
      };
    })
  ]);
}