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
        package = pkgs.helix;
        languages = [
          { name = "rust"; auto-format = true; }
        ];
        settings = {
          theme = "base16";
          keys.normal = {
            y = ":clipboard-yank";
          };
        };
      };
    })
  ]);
}