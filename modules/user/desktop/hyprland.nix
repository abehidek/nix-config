{ inputs, outputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.user.desktop;
  swww = pkgs.swww;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  
  options.modules.user.desktop = {
    hyprland = {
      rice = mkEnableOption "Rices hyprland";
      wallpaper = mkOption { type = types.path; };
      waybar = mkEnableOption "Enable waybar with rice";
      colors = {
        enable = mkEnableOption "Enable colorscheme ricing";
        base16 = mkOption {
          type = types.anything;
          description = "Bas16 colorscheme for kitty terminal";
        };
      };
    };
  };

  config = (mkMerge [
    (mkIf cfg.hyprland.rice (mkMerge [
      {
        # programs.eww = {
        #   enable = true;
        #   package = pkgs.eww-wayland;
        #   configDir = ../../../config/eww;
        # };

        home.packages = [ swww ];

        wayland.windowManager.hyprland = {
          enable = true;
          extraConfig = ''
            autogenerated=0 # remove this line to get rid of the warning on top.

            # STARTUP
            exec-once=${swww}/bin/swww init && ${swww}/bin/swww img ${cfg.hyprland.wallpaper}
            # exec-once={swaylock} -i {wallpaper.path}
            # exec-once=waybar
            # exec-once={swaybg} -i {wallpaper} --mode fill

            exec-once=obsidian
            # exec-once={pkgs.swaybg}/bin/swaybg -i {cfg.hyprland.wallpaper} --mode fill

            monitor=,preferred,auto,1

            monitor=DP-3, 1920x1080, 0x0, 1, transform, 3
            workspace=DP-3,9

            input {
                # list of all xkb https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
                kb_file=
                kb_layout=br,us
                kb_variant=abnt2,alt-intl
                kb_options=grp:win_space_toggle
                kb_rules=

                follow_mouse=1

                touchpad {
                    natural_scroll=yes
                }

                sensitivity=0 # -1.0 - 1.0, 0 means no modification.
            }

            general {
                # main_mod=SUPER

                gaps_in=5
                gaps_out=20
                border_size=2
                col.active_border=0x66ffffff
                col.inactive_border=0x66333333

                apply_sens_to_raw=0 # whether to apply the sensitivity to raw input (e.g. used by games where you aim using your mouse)

                # damage_tracking=full # leave it on full unless you hate your GPU and want to make it suffer
            }

            decoration {
                rounding=5
                blur=1
                blur_size=3 # minimum 1
                blur_passes=1 # minimum 1
                blur_new_optimizations=1
            }

            animations {
                enabled=1
                animation=windows,1,7,default
                animation=border,1,10,default
                animation=fade,1,10,default
                animation=workspaces,1,6,default
            }

            dwindle {
                pseudotile=0 # enable pseudotiling on dwindle
            }

            gestures {
                workspace_swipe=no
            }

            # example window rules
            # for windows named/classed as abc and xyz
            #windowrule=move 69 420,abc
            #windowrule=size 420 69,abc
            #windowrule=tile,xyz
            #windowrule=float,abc
            #windowrule=pseudo,abc
            #windowrule=monitor 0,xyz
            windowrulev2=float,class:^(Rofi)$

            bind=ALT,R,submap,resize # will switch to a submap called resize
            submap=resize # will start a submap called "resize"
              binde=,right,resizeactive,10 0
              binde=,left,resizeactive,-10 0
              binde=,up,resizeactive,0 -10
              binde=,down,resizeactive,0 10
              binde=,escape,submap,reset # use reset to go back to the global submap
            submap=reset # will reset the submap, meaning end the current one and return to the global one.

            # example binds
            bind=SUPER_SHIFT,up,togglegroup,
            bind=SUPER_SHIFT,left,changegroupactive,b
            bind=SUPER_SHIFT,right,changegroupactive,f
            bind=SUPER_SHIFT,down,moveoutofgroup
            bind=CTRL_SUPER,up,moveintogroup,u
            bind=CTRL_SUPER,left,moveintogroup,l
            bind=CTRL_SUPER,right,moveintogroup,r
            bind=CTRL_SUPER,down,moveintogroup,d

            bind=SUPER,F,fullscreen,
            bind=SUPER,Q,exec,kitty
            bind=SUPER,RETURN,exec,alacritty
            bind=SUPER,C,killactive,
            bind=SUPER,M,exit,
            bind=SUPER,E,exec,dolphin
            bind=SUPER,V,togglefloating,
            # bind=SUPER,R,exec,wofi --show drun -o DP-3
            # bind=SUPER,R,exec,rofi -show drun -o DP-3
            bind=SUPER,R,exec,${pkgs.rofi}/bin/rofi -show drun -o DP-3
            bind=SUPER,P,pseudo,
            # bind=SUPER,L,exec,{swaylock} -S

            bind=SUPER,left,movefocus,l
            bind=SUPER,right,movefocus,r
            bind=SUPER,up,movefocus,u
            bind=SUPER,down,movefocus,d

            bind=SUPER,1,workspace,1
            bind=SUPER,2,workspace,2
            bind=SUPER,3,workspace,3
            bind=SUPER,4,workspace,4
            bind=SUPER,5,workspace,5
            bind=SUPER,6,workspace,6
            bind=SUPER,7,workspace,7
            bind=SUPER,8,workspace,8
            bind=SUPER,9,workspace,9
            bind=SUPER,0,workspace,10

            bind=ALT,1,movetoworkspace,1
            bind=ALT,2,movetoworkspace,2
            bind=ALT,3,movetoworkspace,3
            bind=ALT,4,movetoworkspace,4
            bind=ALT,5,movetoworkspace,5
            bind=ALT,6,movetoworkspace,6
            bind=ALT,7,movetoworkspace,7
            bind=ALT,8,movetoworkspace,8
            bind=ALT,9,movetoworkspace,9
            bind=ALT,0,movetoworkspace,10

            bind=SUPER,mouse_down,workspace,e+1
            bind=SUPER,mouse_up,workspace,e-1
          '';
        };
      }
      (mkIf cfg.hyprland.waybar {
        wayland.windowManager.hyprland.extraConfig = ''
          exec-once=waybar
        '';
        programs.waybar = {
          enable = true;
          package = let
            hyprctl = "${pkgs.hyprland}/bin/hyprctl";
            waybarPatchFile = import ./workspace-patch.nix { inherit pkgs hyprctl; };
          in pkgs.waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
            patches = (oldAttrs.patches or [ ]) ++ [ waybarPatchFile ];
            # postPatch = (oldAttrs.postPatch or "") + ''
            #   sed -i 's/zext_workspace_handle_v1_activate(workspace_handle_);/const std::string command = "hyprctl dispatch workspace " + name_;\n\tsystem(command.c_str());/g' src/modules/wlr/workspace_manager.cpp
            # '';
          });
          settings = [{
            layer = "top";
            height = 30;
            margin-bottom = 2;
            margin-top = 0;
            margin-left = 0;
            margin-right = 0;
            modules-left = [
              "wlr/workspaces"
              "sway/mode"
              # "custom/media"
              "hyprland/window"
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
                on-click = "activate";
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
              "hyprland/window" = {
                format = " {}";
              };
              # "sway/window" = {
              #   format = " {}";
              #   max-length = 35;
              #   tooltip = false;
              # };
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
              background-color: #${cfg.hyprland.colors.base16.base00};
              color: #ffffff;
            }
            #workspaces button.hidden,
            #workspaces button {
              background-color: transparent;
              color: #ffffff;
            }
            #workspaces button.active,
            #workspaces button.focused {
              color: #${cfg.hyprland.colors.base16.base0F};
            }
            #workspaces button.urgent {
              background-color: #${cfg.hyprland.colors.base16.base08};
            }
            #mode {
              background-color: transparent;
              color: #${cfg.hyprland.colors.base16.base0F};
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
              color: #${cfg.hyprland.colors.base16.base06};
            }
            #clock,
            #memory,
            #network {
              background-color: #${cfg.hyprland.colors.base16.base01};
            }

            #network.disconnected {
              background-color: #${cfg.hyprland.colors.base16.base0B};
            }        

            #battery,
            #cpu,
            #pulseaudio {
              background-color: #${cfg.hyprland.colors.base16.base03};
            }

            #battery.charging, #battery.plugged {
              color: #${cfg.hyprland.colors.base16.base06};
              background-color: #${cfg.hyprland.colors.base16.base0E};
            }
            @keyframes blink {
              to {
                background-color: #${cfg.hyprland.colors.base16.base03};
                color: #${cfg.hyprland.colors.base16.base06};
              }
            }
            #battery.critical:not(.charging) {
              background-color: #${cfg.hyprland.colors.base16.base0F};
              color: #${cfg.hyprland.colors.base16.base06};
            }

            #pulseaudio.muted {
              background-color: #${cfg.hyprland.colors.base16.base0D};
              color: #${cfg.hyprland.colors.base16.base01};
            }
            #tray {
              background-color: #${cfg.hyprland.colors.base16.base07};
            }

            #tray > .passive {
              -gtk-icon-effect: dim;
            }

            #tray > .needs-attention {
              -gtk-icon-effect: highlight;
              background-color: #${cfg.hyprland.colors.base16.base08};
            }
          '';
        };
      })
      (mkIf cfg.hyprland.colors.enable {
      })
    ]))
  ]);
}