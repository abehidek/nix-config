{ inputs, lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.modules.desktop.hyprland;
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.modules.desktop.hyprland = {
    enable = mkEnableOption "Install and Enable Hyprland";
  };

  config = mkIf cfg.enable {
    programs = {
      hyprland = {
        enable= true;
      };
    };
    security.pam.services.swaylock = {};
  };
}
