{ inputs, outputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.user.desktop;
in {
  options.modules.user.desktop = {
    theme = {
      enable = mkEnableOption "Enable theming in desktop";
      gtk = {
        enable = mkEnableOption "Enable gtk theming in desktop";
        icon = {
          name = mkOption {
            type = types.str;
            description = "Name of the Icon theme to use.";
            example = "Papirus";
          };
          package = mkOption {
            type = types.package;
            description = "Package providing the icon theme.";
            example = "pkgs.papirus-icon-theme";
          };
        };
        theme = {
          name = mkOption {
            type = types.str;
            description = "Name of the GTK+2/3 theme to use.";
            example = "Adwaita";
          };
          package = mkOption {
            type = types.package;
            description = "Package providing the theme.";
            example = "pkgs.gnome.gnome-themes-extra";
          };
        };
      };
      qt = {
        enable = mkEnableOption "Enable qt theming in desktop";
        useGtkTheme = mkEnableOption "Useg GTK theming in QT with qtstylesplugins";
        dolphinBgColor = mkOption {
          type = types.str;
          description = "Hex Color of BackgroundColor property from 'kdeglobals' file, which is used by dolphin";
          example = "#34EBC6";
        };
      };
    };
  };

  config = (mkIf cfg.theme.enable (mkMerge [
    (mkIf cfg.theme.gtk.enable {
      gtk = {
        enable = true;
        theme = {
          name = cfg.theme.gtk.theme.name;
          package = cfg.theme.gtk.theme.package;
        };
        iconTheme = {
          name = cfg.theme.gtk.icon.name;
          package = cfg.theme.gtk.icon.package;
        };
      };
    })
    (mkIf cfg.theme.qt.enable (mkMerge [
      {
        qt = {
          enable = true;
        };
        home.packages = with pkgs; [
          libsForQt5.qt5.qtwayland
          qt6.qtwayland
          pfetch
        ];
        systemd.user.sessionVariables = {
          QT_QPA_PLATFORM = "wayland";
        };
      }
      (mkIf cfg.theme.qt.useGtkTheme {
        qt = {
          platformTheme = "gtk";
        };
        systemd.user.sessionVariables = {
          QT_QPA_PLATFORMTHEME = "gtk2";
        };
      })
      (mkIf (cfg.theme.qt.dolphinBgColor != null) {
        home.file.".config/kdeglobals".text = ''
          [Colors:View]
          BackgroundNormal=${cfg.theme.qt.dolphinBgColor}
        '';
      })
    ]))
  ]));
}
