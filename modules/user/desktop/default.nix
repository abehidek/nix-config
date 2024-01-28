{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.user.desktop;
in {
  imports = [
    ./hyprland.nix
    ./theme.nix
  ];

  options.modules.user.desktop = {
    notifications = {
      mako = {
        enable = mkEnableOption "Install mako daemon";
      };
    };
    term = {
      kitty = {
        enable = mkEnableOption "Install kitty";
        font = {
          enable = mkEnableOption "Assign a font";
          family = mkOption {
            type = types.str;
            description = "Family name for monospace terminal font profile";
            example = "Fira Code";
          };
          package = mkOption {
            type = types.package;
            description = "Package for monospace terminal font profile";
            example = "pkgs.fira-code";
          };
        };
        colors = {
          enable = mkEnableOption "Enable colorscheme ricing";
          base16 = mkOption {
            type = types.anything;
            description = "Bas16 colorscheme for kitty terminal";
          };
        };
      };
    };
  };

  config = (mkMerge [
    (mkIf cfg.notifications.mako.enable (mkMerge [
      {
        home.packages = [ pkgs.libnotify ];
        services.mako.enable = true;
      }
    ]))

    (mkIf cfg.term.kitty.enable (mkMerge [
      {
        programs.kitty = {
          enable = true; 
          extraConfig = ''
            disable_ligatures never
            cursor_shape block
            placement_strategy top-left
          '';
          settings = {
            #allow_remote_control = false;
            # background_opacity = "0.9";
            dynamic_background_opacity = true;
            window_padding_width = 10;
            # map = "kitty_mod+enter launch --cwd=current";
            # map = "kitty_mod+t new_tab_with_cwd";

            map = ''
              kitty_mod+enter launch --cwd=current
              map kitty_mod+t new_tab_with_cwd
            '';
          };
        };
      }
      (mkIf cfg.term.kitty.font.enable {
        fonts.fontconfig.enable = true;
        home.packages = [ cfg.term.kitty.font.package ];
        programs.kitty.font.name = cfg.term.kitty.font.family;
        programs.kitty.font.size = 16;
      })
      (mkIf cfg.term.kitty.colors.enable {
        programs.kitty.settings = {
          foreground = "#${cfg.term.kitty.colors.base16.base05}";
          background = "#${cfg.term.kitty.colors.base16.base00}";
          selection_foreground = "#${cfg.term.kitty.colors.base16.base00}";
          selection_background = "#${cfg.term.kitty.colors.base16.base05}";
          url_color = "#${cfg.term.kitty.colors.base16.base04}";
          cursor = "#${cfg.term.kitty.colors.base16.base05}";

          # black
          color0 = "#${cfg.term.kitty.colors.base16.base00}";
          color8 = "#${cfg.term.kitty.colors.base16.base03}";

          # red
          color1 = "#${cfg.term.kitty.colors.base16.base08}";
          color9 = "#${cfg.term.kitty.colors.base16.base08}";

          # green
          color2 = "#${cfg.term.kitty.colors.base16.base0B}";
          color10 = "#${cfg.term.kitty.colors.base16.base0B}";

          # yellow
          color3 = "#${cfg.term.kitty.colors.base16.base0A}";
          color11 = "#${cfg.term.kitty.colors.base16.base0A}";

          # blue
          color4 = "#${cfg.term.kitty.colors.base16.base0D}";
          color12 = "#${cfg.term.kitty.colors.base16.base0D}";

          # magenta
          color5 = "#${cfg.term.kitty.colors.base16.base0E}";
          color13 = "#${cfg.term.kitty.colors.base16.base0E}";

          # cyan
          color6 = "#${cfg.term.kitty.colors.base16.base0C}";
          color14 = "#${cfg.term.kitty.colors.base16.base0C}";

          # white
          color7 = "#${cfg.term.kitty.colors.base16.base05}";
          color15 = "#${cfg.term.kitty.colors.base16.base07}";

          color16 = "#${cfg.term.kitty.colors.base16.base09}";
          color17 = "#${cfg.term.kitty.colors.base16.base0F}";
          color18 = "#${cfg.term.kitty.colors.base16.base01}";
          color19 = "#${cfg.term.kitty.colors.base16.base02}";
          color20 = "#${cfg.term.kitty.colors.base16.base04}";
          color21 = "#${cfg.term.kitty.colors.base16.base06}";
        };
      })
    ]))
  ]);
}