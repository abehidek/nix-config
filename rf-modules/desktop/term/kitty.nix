{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let 
  cfg = config.hm-modules.desktop.term.kitty;
  inherit (config.colorscheme) colors;
in {
  options.hm-modules.desktop.term.kitty = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font.name = "FiraCode Nerd Font";
      font.size = 16;
      extraConfig = ''
        disable_ligatures never
        cursor_shape block
        placement_strategy top-left
      '';
      settings = {
        #allow_remote_control = false;
        # background_opacity = "0.9";
        dynamic_background_opacity = true;
        window_padding_width = 0;
        # map = "kitty_mod+enter launch --cwd=current";
        # map = "kitty_mod+t new_tab_with_cwd";

        map = ''
          kitty_mod+enter launch --cwd=current
          map kitty_mod+t new_tab_with_cwd
        '';

        foreground = "#${colors.base05}";
        background = "#${colors.base00}";
        selection_foreground = "#${colors.base00}";
        selection_background = "#${colors.base05}";
        url_color = "#${colors.base04}";
        cursor = "#${colors.base05}";

        # black
        color0 = "#${colors.base00}";
        color8 = "#${colors.base03}";

        # red
        color1 = "#${colors.base08}";
        color9 = "#${colors.base08}";

        # green
        color2 = "#${colors.base0B}";
        color10 = "#${colors.base0B}";

        # yellow
        color3 = "#${colors.base0A}";
        color11 = "#${colors.base0A}";

        # blue
        color4 = "#${colors.base0D}";
        color12 = "#${colors.base0D}";

        # magenta
        color5 = "#${colors.base0E}";
        color13 = "#${colors.base0E}";

        # cyan
        color6 = "#${colors.base0C}";
        color14 = "#${colors.base0C}";

        # white
        color7 = "#${colors.base05}";
        color15 = "#${colors.base07}";

        color16 = "#${colors.base09}";
        color17 = "#${colors.base0F}";
        color18 = "#${colors.base01}";
        color19 = "#${colors.base02}";
        color20 = "#${colors.base04}";
        color21 = "#${colors.base06}";
      };
    };
  };
}
