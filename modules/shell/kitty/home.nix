{ lib, config, pkgs, unstable, ... }: 
let colorscheme = import ../../themes/colorscheme;
in {
  programs.kitty = {
    enable = true;
    font.name = "FiraCode Nerd Font";
    font.size = 12;
    extraConfig = ''
      disable_ligatures never
      cursor_shape beam
    '';
    settings = {
      #allow_remote_control = false;
      # background_opacity = "0.9";
      dynamic_background_opacity = true;
      window_padding_width = 0;
      foreground = colorscheme.base05;
      background = colorscheme.base00;
      selection_foreground = colorscheme.base00;
      selection_background = colorscheme.base05;
      url_color = colorscheme.base04;
      cursor = colorscheme.base05;

      # black
      color0 = colorscheme.base00;
      color8 = colorscheme.base03;

      # red
      color1 = colorscheme.base08;
      color9 = colorscheme.base08;

      # green
      color2 = colorscheme.base0B;
      color10 = colorscheme.base0B;

      # yellow
      color3 = colorscheme.base0A;
      color11 = colorscheme.base0A;

      # blue
      color4 = colorscheme.base0D;
      color12 = colorscheme.base0D;

      # magenta
      color5 = colorscheme.base0E;
      color13 = colorscheme.base0E;

      # cyan
      color6 = colorscheme.base0C;
      color14 = colorscheme.base0C;

      # white
      color7 = colorscheme.base05;
      color15 = colorscheme.base07;

      color16 = colorscheme.base09;
      color17 = colorscheme.base0F;
      color18 = colorscheme.base01;
      color19 = colorscheme.base02;
      color20 = colorscheme.base04;
      color21 = colorscheme.base06;
      
    };
  };
}
