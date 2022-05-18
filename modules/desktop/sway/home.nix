{ config, lib, pkgs, unstable, ... }: {
  wayland.windowManager.sway = let
    buildScript = import ../../../lib/buildScript.nix { inherit pkgs; };
    wallpaper = import  ../../themes/wallpaper;
    lockScript = buildScript "lock" ../utils/swaylock/lock.sh {
      bg = wallpaper.bg;
      lock = ../utils/swaylock/lock.svg;
      swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
    };
    import-gsettingsScript =
      buildScript "import-gsettings" ../../themes/gtk/import-gsettings.sh {
        gsettings = "${pkgs.glib}/bin/gsettings";
      };
    colorscheme = import ../../themes/colorscheme;
  in {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      # startup programs and scripts
      startup = [
        { command = "dropbox start"; }
        { command = "lorri daemon"; }
        { command = "${pkgs.autotiling}/bin/autotiling"; }
        {
          command = "${import-gsettingsScript}/bin/import-gsettings";
          always = true;
        }
        # { command = "${pkgs.rofi}/bin/rofi -show"; }
        {
          command =
            "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP";
        }
        {
          command = "swayidle -w before-sleep '${lockScript}/bin/lock'";
        }
        # { command = "pacmd 'set-default-source alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp_6__source'"; }
        {
          command =
            "pacmd 'set-default-source alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0002.hw_sofhdadsp_6__source'";
        }
        # { command = "pacmd 'set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp__sink'"; }
        {
          command =
            "pacmd 'set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0002.hw_sofhdadsp__sink'";
        }
      ];
      menu = "${unstable.rofi-wayland}/bin/rofi -show";
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
      input."type:touch" = { map_to_output = "eDP-1"; };
      # theming
      fonts = {
        names = [ "FiraMono Nerd Font" ];
        style = "Bold";
        size = 10.0;
      };
      output."*" = { bg = "${wallpaper.bg} fill"; };
      gaps.outer = 4;
      gaps.inner = 4;
      #client.focused #eb52eb #eb52eb #eb52eb #eb52eb;
      bars = [{ command = "waybar"; }];
    };
    extraConfig = ''
      default_border pixel 3
      default_floating_border pixel 3
      client.focused ${colorscheme.base0F} ${colorscheme.base0F} ${colorscheme.base00} ${colorscheme.base0F} ${colorscheme.base0F}
      client.focused_inactive ${colorscheme.base04} ${colorscheme.base04} ${colorscheme.base00} ${colorscheme.base04} ${colorscheme.base04}
      client.unfocused ${colorscheme.base04} ${colorscheme.base04} ${colorscheme.base00} ${colorscheme.base04} ${colorscheme.base04}
      bindsym Mod4+Control+Shift+Right move workspace to output right
      bindsym Mod4+Control+Shift+Left move workspace to output left
      bindsym Mod4+Control+Shift+Down move workspace to output down
      bindsym Mod4+Control+Shift+Up move workspace to output up
      bindsym Print+s exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save area
      bindsym Print+c exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy area
      bindsym Mod4+Print+s exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify save active
      bindsym Mod4+Print+c exec ${pkgs.sway-contrib.grimshot}/bin/grimshot --notify copy active
      bindsym Mod4+p exec ${unstable.cinnamon.nemo}/bin/nemo
      for_window [title="Ulauncher"] border none
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
    # export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    # export QT_QPA_PLATFORM=wayland-egl
  };
}
