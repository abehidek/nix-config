{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop.kde;
in {
  options.modules.desktop.kde = {
    enable = mkEnableOption "Install and Enable KDE";
  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
    };
  };
}
