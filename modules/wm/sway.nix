{ config, lib, pkgs, ... }:
{
  imports =
  [
    # Modules used by the wm
    ../xdg # XDG Settings
    # ../mpd # MPD Settings
    ../terminal # Terminal settings
  ];
  programs.qt5ct.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [ 
      xwayland wl-clipboard 
      swayidle waybar wlr-randr wdisplays 
      mako autotiling waypipe drm_info phwmon
    ];
  };
  home-manager.users.abe = {
    imports = [
      ../waybar # Waybar settings
      ../swaylock-effects
      ../theme # Import Theme
    ];
    wayland.windowManager.sway =
    let
      buildScript = import ../buildScript.nix;
      wallpaper = import ../theme/wallpaper.nix;
      lockScript = buildScript "lock" ../swaylock-effects/lock {
        bg = wallpaper.bg;
        lock = ../swaylock-effects/lock.svg;
        swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
      };
      import-gsettingsScript = buildScript "import-gsettings" ../../scripts/import-gsettings.sh {
        gsettings = "${pkgs.glib}/bin/gsettings";
      };
      colorscheme = import ../theme/colorscheme;
    in
    {
      enable = true;
      wrapperFeatures.gtk = true;

      config = {
        # startup programs and scripts
        startup = [
          { command = "dropbox start";}
          { command = "lorri daemon"; }
          { command = "${pkgs.autotiling}/bin/autotiling";}
          { command = "${import-gsettingsScript}/bin/import-gsettings"; always = true; }
          { command = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
          { command = "swayidle -w before-sleep '${lockScript}/bin/lock'"; }
          # { command = "pacmd 'set-default-source alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp_6__source'"; }
          { command = "pacmd 'set-default-source alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0002.hw_sofhdadsp_6__source'"; }
          # { command = "pacmd 'set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp__sink'"; }
          { command = "pacmd 'set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0002.hw_sofhdadsp__sink'"; }
        ];
        menu = "${pkgs.wofi}/bin/wofi --show run swaymsg exec --";
        terminal = "${pkgs.kitty}/bin/kitty";

        # screens
        output."eDP-1" = {
          pos = "0 1080";
          #scale = "1.25";
          resolution = "--custom 1600x900";
        };
        output."HDMI-A-1" = {
          pos = "0 0";
          res = "1920x1080";
        };

        # input and keybinds
        modifier = "Mod4";
        keybindings = let
          mod = "Mod4";
          audio = "exec ${pkgs.pamixer}/bin/pamixer";
          light = "exec ${pkgs.brightnessctl}/bin/brightnessctl";
          terminal = "${pkgs.kitty}/bin/kitty";
        in lib.mkOptionDefault {
          XF86AudioRaiseVolume = "${audio} -i 5";
          XF86AudioLowerVolume = "${audio} -d 5";
          XF86AudioMute = "${audio} -t";
          XF86AudioMicMute = "${audio} --default-source -t";
          XF86MonBrightnessDown = "${light} set 5%-";
          XF86MonBrightnessUp = "${light} set +5%";
          "${mod}+l" = "exec ${lockScript}/bin/lock";
          #"${mod}+e" = "exec ${terminal} ranger";
        };
        input."1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout = "br";
          xkb_model = "abnt2";
        };
        input."1241:41619:OBINS_OBINS_AnnePro2" = {
          xkb_layout = "us";
          xkb_variant = "intl";
        };
        input."type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          scroll_method = "two_finger";
        };
        input."type:touch" = {
          map_to_output = "eDP-1";
        };
        # theming
        output."*" = { bg = "${wallpaper.bg} fill"; };
        gaps.outer = 10;
        gaps.inner = 10;
        #client.focused #eb52eb #eb52eb #eb52eb #eb52eb;
        bars = [{ command = "waybar"; }];      
      };
      extraConfig = ''
        default_border pixel 3
        default_floating_border pixel 3
        client.focused ${colorscheme.cyan} ${colorscheme.cyan} ${colorscheme.cyan} ${colorscheme.cyan} ${colorscheme.cyan}
        client.focused_inactive ${colorscheme.white} ${colorscheme.white} ${colorscheme.white} ${colorscheme.white} ${colorscheme.white}
        client.unfocused ${colorscheme.white} ${colorscheme.white} ${colorscheme.white} ${colorscheme.white} ${colorscheme.white}
        bindsym Mod4+Control+Shift+Right move workspace to output right
        bindsym Mod4+Control+Shift+Left move workspace to output left
        bindsym Mod4+Control+Shift+Down move workspace to output down
        bindsym Mod4+Control+Shift+Up move workspace to output up
      '';
      #client.focused #2E3440 #2E3440 #ECEFF4 #2E3440 #2E3440
      
      extraSessionCommands = ''
        export GTK_USE_PORTAL=1 
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export MOZ_ENABLE_WAYLAND=1
        export CLUTTER_BACKEND=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_QPA_PLATFORM=wayland-egl
        export QT_QPA_PLATFORMTHEME=qt5ct
        export ECORE_EVAS_ENGINE=wayland-egl
        export ELM_ENGINE=wayland_egl
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export NO_AT_BRIDGE=1
        export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh
      '';
    };
    # export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # export QT_QPA_PLATFORM=wayland-egl
  };
}
