{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.editors.vscodium;
in {
  options.modules.editors.vscodium = {
    enable = mkEnableOption "Install VSCodium";
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [ unstable.vscodium ];
    };
  };
}
