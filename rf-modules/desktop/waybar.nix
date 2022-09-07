{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let cfg = config.hm-modules.desktop.waybar;
in {
  options.hm-modules.desktop.waybar = {
    enable = mkEnableOption false;
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar;
      settings = [{
        height = 30;
        margin-bottom = 2;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        modules-left = [
          "wlr/workspaces"
          "sway/mode"
          # "custom/media"
          "sway/window"
        ];
        #modules-center = [ "clock" ];
        modules-right = [
          # "mpd" 
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "battery"
          "battery#bat2"
          "tray"
          "clock"
        ];
        modules = {
          "wlr/workspaces" = {
            all-outputs = true;
            disable-scroll = true;
            format = "  {icon}  ";
            format-icons = {
              # "1" = "壱";
              # "2" = "弐";
              # "3" = "参";
              # "4" = "肆";
              # "5" = "伍";
              # "6" = "陸";
              # "7" = "漆";
              # "8" = "捌";
              # "9" = "玖";
              "1" = "一";
              "2" = "二";
              "3" = "三";
              "4" = "四";
              "5" = "五";
              "6" = "六";
              "7" = "七";
              "8" = "八";
              "9" = "九";
              focused = "";
              urgent = "";
              default = "";
            };
          };
          "sway/mode" = { format = ''<span style="italic">{}</span>''; };
          "sway/window" = {
            format = " {}";
            max-length = 35;
            tooltip = false;
          };
          # "custom/media" = {
          #   format = "{icon} {}";
          #   return-type = "json";
          #   max-length = 40;
          #   format-icons = {
          #     spotify = "";
          #   };
          #   escape = true;
          # };
          # CENTER MODULES
          clock = {
            format = "{:%H:%M - %d/%m/%Y}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };
          # RIGHT MODULES
          pulseaudio = {
            scroll-step = 1;
            format = "{volume}% {icon} {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = "{volume}% ";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [ "" "" "" ];
            };
            on-click = "pavucontrol";
          };
          network = {
            interface = "wlp0s20f3";
            interval = "5";
            format-wifi = "{essid} ({signalStrength}%) ";
            format-ethernet = "Ethernet ";
            format-linked = "Ethernet (No IP) ";
            format-disconnected = "Disconnected ";
            format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
            # on-click-middle = "nm-connection-editor";
          };
          cpu = { format = "{usage}% "; };
          memory = { format = "{}% "; };
          battery = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{capacity}% {icon} ";
            format-charging = "{capacity}% ";
            format-plugged = "{capacity}% ";
            format-alt = "{time} {icon}";
            format-icons = [ "" "" "" "" "" ];
          };
          "battery#bat2" = { bat = "BAT2"; };
          # "custom/power" = {
          #   format = "{icon}";
          #   format-icons = "";
          #   on-click = "${pkgs.wlogout}/bin/wlogout";
          #   escape = true;
          #   tooltip = false;
          # };
        };
      }];
      # background-color: ${colorscheme.base06};
      # color: ${colorscheme.base00};
    };
  };
}
