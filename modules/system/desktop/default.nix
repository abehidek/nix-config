{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.system.desktop;
in {
  options.modules.system.desktop = {
    gnome = {
      enable = mkEnableOption "Enables gnome for all users";
      minimal = mkEnableOption "Removes unused gnome applications";
    };
  };

  config = (mkMerge [
    (mkIf cfg.gnome.enable (mkMerge [
      {
        services.xserver = {
          enable = true;
          desktopManager.gnome.enable = true;
        };
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
