{ lib, config, pkgs, name, user, ... }:
with lib;
let cfg = config.hm-modules.editors.vscodium;
in {
  options.hm-modules.editors.vscodium = {
    enable = mkEnableOption "Install VSCodium";
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ vscodium ];
    };
  };
}
