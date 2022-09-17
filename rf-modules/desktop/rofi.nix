{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let 
  cfg = config.hm-modules.desktop.rofi;
  inherit (config.colorscheme) colors;
  inherit (config.lib.formats.rasi) mkLiteral;
in {
  options.hm-modules.desktop.rofi = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      terminal = "${pkgs.kitty}/bin/kitty";
      extraConfig = {
        modi = "drun,run,ssh";
      };
      theme = {
        "*" = {
          bg0 = mkLiteral "#${colors.base00}";
          bg1 = mkLiteral "#${colors.base01}";
          fg0 = mkLiteral "#${colors.base05}";
          fg1 = mkLiteral "#${colors.base06}";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "element-icon, element-text, scrollbar" = {
          cursor = mkLiteral "pointer";
        };

        "window" = {
          location = mkLiteral "northwest";
          width = mkLiteral "280px";
          x-offset = mkLiteral "8px";
          y-offset = mkLiteral "24px";

          background-color = mkLiteral "@bg0";
          border = mkLiteral "1px";
          border-color = mkLiteral "@bg1";
          border-radius = mkLiteral "6px";
        };

        "inputbar" = {
          spacing = mkLiteral "8px";
          padding = mkLiteral "4px 8px";
          children = mkLiteral "[ icon-search, entry ]";

          #background-color = mkLiteral "@bg0";
          background-color = mkLiteral "@bg0";
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        "icon-search" = {
          expand = false;
          filename = mkLiteral "[ search-symbolic ]";
          size = mkLiteral "14px";
        };

        "textbox" = {
          padding = mkLiteral "4px 8px";
          background-color = mkLiteral "@bg0";
        };

        "listview" = {
          padding = mkLiteral "4px 0px";
          lines = 12;
          columns = 1;
          scrollbar = true;
          fixed-height = false;
          dynamic = true;
        };

        "element" = {
          padding = mkLiteral "4px 8px";
          spacing = mkLiteral "8px";
        };

        "element normal urgent" = {
          text-color = mkLiteral "@fg1";
        };

        "element normal active" = {
          text-color = mkLiteral "@fg1";
        };

        "element selected" = {
          text-color = mkLiteral "@bg0"; #1
          background-color = mkLiteral "@fg1";
        };

        "element selected urgent" = {
          background-color = mkLiteral "@fg1";
        };

        "element-icon" = {
          size = mkLiteral "0.8em";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };

        "scrollbar" = {
          handle-width = mkLiteral "4px";
          handle-color = mkLiteral "@fg1";
          padding = mkLiteral "0 4px";
        };
      };
    };
  };
}
