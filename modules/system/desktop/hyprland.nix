{ inputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  imports = [
    inputs.hyprland.nixosModules.default
  ];

  options.modules.system.desktop = {
    hyprland = {
      enable = mkEnableOption "Enables hyprland for all users";
    };
  };

  config = (mkMerge [
    (mkIf cfg.hyprland.enable (mkMerge [
      {
        programs.dconf.enable = true;
        systemd.services.upower.enable = true; # start upower service
        services = {
          upower.enable = true; # install upower
        };
        programs = {
          hyprland = {
            enable= true;
          };
        };
        environment.systemPackages = with pkgs; [
          wl-clipboard
          wlr-randr
        ];
        security.pam.services.swaylock = {};
      }
    ]))
  ]);
}
