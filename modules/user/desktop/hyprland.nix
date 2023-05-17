{ inputs, outputs, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.user.desktop;
in {
  imports = [
    inputs.hyprland.homeManagerModules.default
  ];
  
  options.modules.user.desktop = {
    hyprland = {
      rice = mkEnableOption "Rices hyprland";
      waybar = mkEnableOption "Enable waybar with rice";
      hyprpicker = mkEnableOption "Installs hyprpicker";
      shotman = mkEnableOption "Enables shotman";
      swaylock = {
        enable = mkEnableOption "Enable swaylock";
        lockOnSleep = mkEnableOption "Runs swaylock before sleeping";
      };
      terminal = mkOption {
        type = types.str;
        default = "alacritty";
        example = "kitty";
        description = "What terminal to launch on bind";
      };
      wallpaper = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enables wallpaper";
        };
        path = mkOption { type = types.path; };
        utility = mkOption {
          type = types.enum [ "swaybg" "swww" ];
          default = "swww";
          description = "Selects your wallpaper utility to use";
        };
      };
      enableAnimations = mkOption {
        type = types.bool;
        default = true;
        description = "Enable animations on hyprland";
      };
      font = {
        family = mkOption {
          type = types.str;
          description = "Family name for UI font";
          example = "Fira Code";
        };
        package = mkOption {
          type = types.package;
          description = "Package for UI font";
          example = "pkgs.fira-code";
        };
      };
      colorScheme = mkOption {
        type = types.anything;
        description = "Bas16 colorscheme for kitty terminal";
      };
    };
  };

  config = let
    swaylock = "${pkgs.swaylock-effects}/bin/swaylock --screenshots --indicator-radius 40 --indicator-thickness 6 --ring-color ${cfg.hyprland.colorScheme.base05} --key-hl-color ${cfg.hyprland.colorScheme.base04} --effect-blur 7x5 --effect-vignette 0.5:0.5";
  in (mkMerge [
    (mkIf cfg.hyprland.rice (mkMerge [
      (mkIf cfg.hyprland.wallpaper.enable (mkMerge [
        (mkIf (cfg.hyprland.wallpaper.utility == "swww") {
          home.packages = [ pkgs.swww ];
          wayland.windowManager.hyprland.extraConfig = ''
            exec-once=${pkgs.swww}/bin/swww init && ${pkgs.swww}/bin/swww img ${cfg.hyprland.wallpaper.path}
          '';
        })
        (mkIf (cfg.hyprland.wallpaper.utility == "swaybg") {
          home.packages = [ pkgs.swaybg ];
          wayland.windowManager.hyprland.extraConfig = ''
            exec-once=${pkgs.swaybg}/bin/swaybg -i ${cfg.hyprland.wallpaper.path} --mode fill
          '';
        })
      ]))
      (mkIf cfg.hyprland.waybar (mkMerge [
        {
          wayland.windowManager.hyprland.extraConfig = ''
            exec-once=waybar
          '';
          # Download specified font
          fonts.fontconfig.enable = true;
          home.packages = [ cfg.hyprland.font.package pkgs.ipafont ];

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
              height = 40;
              margin-bottom = 2;
              margin-top = 0;
              margin-left = 0;
              margin-right = 0;
              modules-left = [
                "wlr/workspaces"
                "hyprland/window"
              ];
              modules-center = [];
              modules-right = [
                "pulseaudio"
                "pulseaudio#microphone"
                "network"
                "cpu"
                "memory"
                "battery"
                "tray"
                "hyprland/language"
                "clock"
              ];
              modules = {
                "wlr/workspaces" = {
                  persistent_workspaces = {
                    "1" = [];
                    "2" = [];
                    "3" = [];
                    "4" = [];
                    "5" = [];
                    "6" = [];
                    "7" = [];
                    "8" = [];
                    "9" = [];
                    "10" = [];
                  };
                  active-only = false;
                  sort-by-number = true;
                  on-click = "activate";
                  all-outputs = false;
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
                    "10" = "​拾";
                    # "1" = "一";
                    # "2" = "二";
                    # "3" = "三";
                    # "4" = "四";
                    # "5" = "五";
                    # "6" = "六";
                    # "7" = "七";
                    # "8" = "八";
                    # "9" = "九";
                    focused = "";
                    urgent = "";
                    default = "";
                  };
                };
                "hyprland/window" = {
                  format = "{}";
                };              
                # RIGHT MODULES
                pulseaudio = {
                  scroll-step = 1;
                  format = "{icon} {volume}%";
                  format-muted = " Muted";
                  format-bluetooth = "{icon} {volume}%";
                  format-bluetooth-muted = "{icon}  Muted";
                  format-icons = {
                    headphone = "";
                    hands-free = "";
                    headset = "";
                    phone = "";
                    portable = "";
                    car = "";
                    default = [ "" "" "" ];
                  };
                  on-click = "pavucontrol";
                };
                "pulseaudio#microphone" = {
                  scroll-step = 5;
                  format = "{format_source}";
                  format-source = " {volume}%";
                  format-source-muted = " Muted";
                  on-click = "pavucontrol";
                  tooltip = false;
                };
                network = {
                  interface = "wlp0s20f3";
                  interval = "5";
                  format-wifi = " ";
                  format-ethernet = " ";
                  format-linked = "(No IP) 󰈀 ";
                  format-disconnected = "";
                  tooltip-format = "{ifname} via {gwaddr}";
                  tooltip-format-wifi = "{essid} ({signalStrength}%) ";
                  tooltip-format-ethernet = "{ifname} 󰈀";
                  tooltip-format-disconnected = "Disconnected ";
                  # on-click-middle = "nm-connection-editor";
                };
                cpu = { format = "{usage}% "; };
                memory = { format = "{}% 󰍛"; };
                battery = {
                  states = {
                    warning = 30;
                    critical = 15;
                  };
                  format = "{capacity}% {icon} ";
                  format-charging = "{capacity}% 󰂄";
                  format-plugged = "{capacity}% 󰂄";
                  format-alt = "{time} {icon}";
                  format-icons = [ "" "" "" "" "" ];
                };
                tray = {
                  icon-size = 16;
                  spacing = 10;
                };
                "hyprland/language" = {
                  format = "{}";
                };
                clock = {
                  format = "{:%d/%m %H:%M}";
                };
              };
            }];
            style = ''
              * {
                font-family: ${cfg.hyprland.font.family};
                font-size: 12px;
              }
              
              window#waybar { background-color: transparent; }

              #workspaces {
                background-color: transparent;
                margin-top: 10px;
                margin-bottom: 10px;
                
                margin-right: 10px;
                margin-left: 25px;
              }

              #workspaces button {
                font-family: IPAPMincho;
                background: #${cfg.hyprland.colorScheme.base00};
                background: radial-gradient(circle, #${cfg.hyprland.colorScheme.base00} 0%, #${cfg.hyprland.colorScheme.base00} 100%);
                border-radius: 15px;
                margin-right: 10px;
                padding: 10px;
                padding-top: 4px;
                padding-bottom: 3px;
                font-weight: bolder;
                color: #${cfg.hyprland.colorScheme.base03};
                transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
              }

              @keyframes gradient_f {
                0% {
                  background-position: 0% 200%;
                }
                  50% {
                      background-position: 200% 0%;
                  }
                100% {
                  background-position: 400% 200%;
                }
              }

              #workspaces button.active {
                padding-right: 20px;
                padding-left: 20px;
                background: #${cfg.hyprland.colorScheme.base0E};
                background: radial-gradient(circle, #${cfg.hyprland.colorScheme.base0E} 0%, #${cfg.hyprland.colorScheme.base0D} 14%, #${cfg.hyprland.colorScheme.base0C} 28%, #${cfg.hyprland.colorScheme.base0B} 42%, #${cfg.hyprland.colorScheme.base0A} 57%, #${cfg.hyprland.colorScheme.base09} 71%, #${cfg.hyprland.colorScheme.base08} 100%);
                background-size: 400% 400%;
                animation: gradient_f 10s ease-in-out infinite;
                transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.682);
                color: #${cfg.hyprland.colorScheme.base00};
              }

              /* Center */

              #window {
                background-color: #${cfg.hyprland.colorScheme.base00};
                border-radius: 15px;
                color: #${cfg.hyprland.colorScheme.base05};
                padding-right: 20px;
                padding-left: 20px;
                padding-top: 4px;
                padding-bottom: 3px;
                
                margin-top: 10px;
                margin-bottom: 10px;
              }

              /* Right */
              #pulseaudio,
              #pulseaudio.microphone,
              #network,
              #cpu,
              #memory,
              #battery,
              #tray,
              #language,
              #clock {
                background-color: #${cfg.hyprland.colorScheme.base05};
                border-radius: 15px;
                color: #${cfg.hyprland.colorScheme.base00};
                padding-right: 20px;
                padding-left: 20px;
                padding-top: 4px;
                padding-bottom: 3px;
                font-weight: 500;

                margin-top: 10px;
                margin-bottom: 10px;
                margin-right: 10px;
              }

              #pulseaudio { background-color: #${cfg.hyprland.colorScheme.base08}; }
              #pulseaudio.microphone { background-color: #${cfg.hyprland.colorScheme.base09}; }
              #network { background-color: #${cfg.hyprland.colorScheme.base0A}; }
              #cpu { background-color: #${cfg.hyprland.colorScheme.base0B}; }
              #memory { background-color: #${cfg.hyprland.colorScheme.base0C}; }
              #battery { background-color: #${cfg.hyprland.colorScheme.base0D}; }
              #tray {
                background-color: #${cfg.hyprland.colorScheme.base00};
                padding-bottom: 4px;
              }
              #clock {
                background-color: #${cfg.hyprland.colorScheme.base05};
                color: #${cfg.hyprland.colorScheme.base00};
              }
            '';
          };
        }
      ]))
      (mkIf cfg.hyprland.enableAnimations {
        wayland.windowManager.hyprland = {
          extraConfig = ''
            animations {
                enabled=1
                animation=windows,1,7,default
                animation=border,1,10,default
                animation=fade,1,10,default
                animation=workspaces,1,6,default
            }
          '';
        };
      })
      (mkIf (cfg.hyprland.enableAnimations == false) {
        wayland.windowManager.hyprland = {
          extraConfig = ''
            animations {
                enabled=0
            }
          '';
        };
      })
      {
        # programs.eww = {
        #   enable = true;
        #   package = pkgs.eww-wayland;
        #   configDir = ../../../config/eww;
        # };
        wayland.windowManager.hyprland = {
          enable = true;
          extraConfig = ''
            autogenerated=0 # remove this line to get rid of the warning on top.

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
            bind=SUPER,Q,exec,${cfg.hyprland.terminal}
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

            # For Pipewire Screensharing
            exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
          '';
        };
      }
      (mkIf cfg.hyprland.shotman {
        home.packages = with pkgs; [ shotman grim slurp ];
        wayland.windowManager.hyprland.extraConfig = ''
          bind=SUPER,Print,exec,${pkgs.shotman}/bin/shotman --capture=output
          bind=SUPER_SHIFT,Print,exec,${pkgs.shotman}/bin/shotman --capture=region
        '';
      })
      (mkIf cfg.hyprland.hyprpicker {
        home.packages = [ pkgs.hyprpicker pkgs.wl-clipboard ];
        wayland.windowManager.hyprland.extraConfig = ''
          bind=SUPER,i,exec,${pkgs.hyprpicker}/bin/hyprpicker --autocopy
        '';
      })
      (mkIf cfg.hyprland.swaylock.enable (mkMerge [
        {
          home.packages = with pkgs; [ swaylock-effects grim ];
          wayland.windowManager.hyprland.extraConfig = ''
            bind=SUPER,l,exec,${swaylock}
          '';
        }
        (mkIf cfg.hyprland.swaylock.lockOnSleep {
          home.packages = with pkgs; [ swayidle ];
          services.swayidle = {
            enable = true;
            events = [
              { event = "before-sleep"; command = "${swaylock} -fF"; }
              { event = "lock"; command = "${swaylock} -fF"; }
            ];
            # timeouts = [
            #   {
            #     timeout = 310;
            #     command = "${pkgs.systemd}/bin/loginctl lock-session";
            #   }
            # ];
          };
          systemd.user.services.swayidle.Install.WantedBy = lib.mkForce [ "hyprland-session.target" ];
        })
      ]))
    ]))
  ]);
}