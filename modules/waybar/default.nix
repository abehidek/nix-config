{ lib, config, pkgs, ... }:
let 
  theme = import ../theme;
in 
{
  environment = {
    systemPackages = with pkgs; [];
  };
  home-manager.users.abe = {
    home = {
      file = {
        # ".config/waybar/config".source = ./waybar.sh;
        ".config/waybar/style.css".source = ./style.css;
      };
    };
    programs.waybar = {
        enable = true;
        settings = [{
          height = 35;
          margin-bottom = 5;
          margin-top = 20;
          margin-left = 20;
          margin-right = 20;
          modules-left = [
            "sway/workspaces"
            "sway/mode"
            # "custom/media"
            "sway/window"
          ];
          modules-center = [ "clock" ];
          modules-right = [ 
            # "mpd" 
            "pulseaudio" 
            "network" "cpu" "memory" "battery" "battery#bat2"
            "tray" ];
          modules = {
            "sway/workspaces" = {
              all-outputs = true;
              disable-scroll = true;
              format = "  {icon}  ";
              format-icons = {
                "1" = "壱";
                "2" = "弐";
                "3" = "参";
                "4" = "肆";
                "5" = "伍";
                "6" = "陸";
                "7" = "漆";
                "8" = "捌";
                "9" = "玖";
                focused = "";
                urgent = "";
                default = "";
              };
            };
            "sway/mode" = {
              format = "<span style=\"italic\">{}</span>";
            };
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
              tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
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
              format-wifi = "{essid} ({signalStrength}%) ";
              format-ethernet = "Ethernet ";
              format-linked = "Ethernet (No IP) ";
              format-disconnected = "Disconnected ";
              format-alt = "{bandwidthDownBits}/{bandwidthUpBits}";
              # on-click-middle = "nm-connection-editor";
            };
            cpu = {
              format = "{usage}% ";
            };
            memory = {
              format = "{}% ";
            };
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
            "battery#bat2" = {
              bat = "BAT2";
            };
          };
        }];
      };
  };
}