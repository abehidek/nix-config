{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  imports = [
    ./xmonad.nix
    ./hyprland.nix
  ];

  options.modules.system.desktop = {
    gnome = {
      enable = mkEnableOption "Enables gnome for all users";
      minimal = mkEnableOption "Removes unused gnome applications";
    };
  };

  config = (mkMerge [
    (mkIf cfg.gnome.enable (mkMerge [
      {
        environment = {
          systemPackages = with pkgs; [
            gnomeExtensions.appindicator
            gnome.gnome-session
            xclip
            xorg.xrandr
          ];
          shellAliases = {
            logout-gnome = "gnome-session-quit";
          };
        };
        programs.dconf.enable = true;
        services.xserver = {
          enable = true;
          desktopManager.gnome.enable = true;
        };
        services.udev.packages = with pkgs; [
          gnome.gnome-settings-daemon
        ];
      }
      (mkIf cfg.gnome.minimal {
        environment.gnome.excludePackages = (with pkgs; [
          gnome-tour
        ]) ++ (with pkgs.gnome; [
          gnome-terminal
          gedit # text editor
          epiphany # web browser
          geary # email reader
          evince # document viewer
          gnome-characters
          tali # poker game
          iagno # go game
          hitori # sudoku game
          atomix # puzzle game
        ]);
      })
    ]))
  ]);
}
