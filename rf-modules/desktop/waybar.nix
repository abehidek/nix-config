{ lib, config, pkgs, unstable, name, user, ... }:
with lib;
let
  cfg = config.hm-modules.desktop.waybar;
  inherit (config.colorscheme) colors;
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
      style = ''
        * {
          /* `otf-font-awesome` is required to be installed for icons */
          border: none;
          border-radius: 0;
          font-size: 14px;
          margin: 0;
        }

        .modules-left {
          /* border-radius: 15px; */
          padding: 5 15px;
          margin: 0 0px;
        }

        window#waybar {
          transition-duration: .5s;
        }

        window#waybar.chromium {
          /* background-color: #000000; */
          border: none;
        }

        #workspaces button {
          padding: 0 5px;
          font-family: 'IPAPMincho';
          font-weight: bold;
          border-radius: 10px;
          border: none;
        }

        #window,
        #mode
        {
          font-family: 'FiraCode Nerd Font';
        }

        /* If workspaces is the leftmost module, omit left margin */
        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }

        /* If workspaces is the rightmost module, omit right margin */
        .modules-right > widget:last-child > #workspaces {
          margin-right: 0;
        }

        /* COMPONENTS HERE */

        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #network,
        #pulseaudio,
        #custom-media,
        #tray,
        #mpd {
          border-radius: 0px;
          font-family: 'FiraCode Nerd Font';
          padding: 5 15px;
          margin-left: 0px;
        }

        #custom-power {
          border-radius: 0px;
          font-family: 'FiraCode Nerd Font';
          padding: 5 20px;
          margin-left: 0px;
        }

        #battery.critical:not(.charging) {
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        /* label:focus {
          background-color: #000000;
        } */

        /* #disk {
          background-color: #964B00;
        } */

        /* #custom-media {
          background-color: #66cc99;
          color: #2a5c45;
          min-width: 100px;
        }

        #custom-media.custom-spotify {
          background-color: #66cc99;
        }

        #custom-media.custom-vlc {
          background-color: #ffa000;
        } */

        /* #mpd {
          background-color: #66cc99;
          color: #2a5c45;
        }

        #mpd.disconnected {
          background-color: #f53c3c;
        }

        #mpd.stopped {
          background-color: #90b1b1;
        }

        #mpd.paused {
          background-color: #51a37a;
        } */

        /* #language {
          background: #00b093;
          color: #740864;
          padding: 0 10px;
          margin: 0 0px;
          min-width: 20px;
        }

        #keyboard-state {
          background: #97e1ad;
          color: #000000;
          padding: 0 0px;
          margin: 0 0px;
          min-width: 16px;
        }

        #keyboard-state > label {
          padding: 0 0px;
        }

        #keyboard-state > label.locked {
          background: rgba(0, 0, 0, 0.2);
        } */

        /* #idle_inhibitor {
          background-color: #2d3436;
        }

        #idle_inhibitor.activated {
          background-color: #ecf0f1;
          color: #2d3436;
        } */

        /* #temperature {
          background-color: #f0932b;
        }

        #temperature.critical {
          background-color: #eb4d4b;
        } */

        /* #backlight {
          background-color: #90b1b1;
        } */

        .modules-left {
          background-color: transparent;
          color: #ffffff;
        }
        .modules-right {
          background-color: transparent;
        }
        window#waybar {
          background-color: #${colors.base00};
          color: #ffffff;
        }
        #workspaces button {
          background-color: transparent;
          color: #ffffff;
        }
        #workspaces button.active,
        #workspaces button.focused {
          color: #${colors.base0F};
        }
        #workspaces button.urgent {
          background-color: #${colors.base08};
        }
        #mode {
          background-color: transparent;
          color: #${colors.base0F};
        }
        #clock,
        #battery,
        #cpu,
        #memory,
        #disk,
        #network,
        #pulseaudio,
        #custom-media,
        #tray,
        #mpd {
          color: #${colors.base06};
        }
        #clock,
        #memory,
        #network {
          background-color: #${colors.base01};
        }

        #network.disconnected {
          background-color: #${colors.base0B};
        }        

        #battery,
        #cpu,
        #pulseaudio {
          background-color: #${colors.base03};
        }

        #battery.charging, #battery.plugged {
          color: #${colors.base06};
          background-color: #${colors.base0E};
        }
        @keyframes blink {
          to {
            background-color: #${colors.base03};
            color: #${colors.base06};
          }
        }
        #battery.critical:not(.charging) {
          background-color: #${colors.base0F};
          color: #${colors.base06};
        }

        #pulseaudio.muted {
          background-color: #${colors.base0D};
          color: #${colors.base01};
        }
        #tray {
          background-color: #${colors.base07};
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #${colors.base08};
        }
      '';
    };
  };
}
