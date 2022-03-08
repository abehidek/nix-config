{ lib, config, pkgs, ... }:
{

programs.sway = {
  enable = true;
  wrapperFeatures.gtk = true;
  extraPackages = with pkgs; [ 
    xwayland wl-clipboard 
    swayidle waybar wlr-randr wdisplays 
    mako autotiling waypipe swaylock-effects 
    swaylock-fancy drm_info phwmon 
  ];
};

home-manager.users.abe.wayland.windowManager.sway =
let
  buildScript = import ../buildScript.nix;
  wallpaper = /home/abe/Imagens/nordic-wallpapers/wallpapers/nixos.png ;
  lockScript = buildScript "lock" ../swaylock/lock {
    bg = wallpaper;
    lock = ../swaylock-effects/lock.svg;
    swaylock = "${pkgs.swaylock-effects}/bin/swaylock";
  };
  import-gsettingsScript = buildScript "import-gsettings" ../../scripts/import-gsettings.sh {
    gsettings = "${pkgs.glib}/bin/gsettings";
  };
in
{
  enable = true;
  wrapperFeatures.gtk = true;

  config = {
    # startup programs and scripts
    startup = [
      { command = "dropbox start";}
      { command = "${pkgs.autotiling}/bin/autotiling";}
      { command = "${import-gsettingsScript}/bin/import-gsettings"; always = true; }
      { command = "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"; }
      { command = "swayidle -w before-sleep '${pkgs.swaylock-fancy}/bin/swaylock-fancy'"; }
      # { command = "pacmd 'set-default-source alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp_6__source'"; }
      { command = "pacmd 'set-default-source alsa_input.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0002.hw_sofhdadsp_6__source'"; }
      # { command = "pacmd 'set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0001.hw_sofhdadsp__sink'"; }
      { command = "pacmd 'set-default-sink alsa_output.pci-0000_00_1f.3-platform-skl_hda_dsp_generic.HiFi___ucm0002.hw_sofhdadsp__sink'"; }
    ];
    menu = "${pkgs.wofi}/bin/wofi --show run swaymsg exec --";
    terminal = "${pkgs.xterm}/bin/xterm -fg white -bg black";

    # screens
    output."Virtual-1" = {
      pos = "0 0";
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
      terminal = "${pkgs.xterm}/bin/xterm -fg white -bg black";
    in lib.mkOptionDefault {
      XF86AudioRaiseVolume = "${audio} -i 5";
      XF86AudioLowerVolume = "${audio} -d 5";
      XF86AudioMute = "${audio} -t";
      XF86AudioMicMute = "${audio} mute-input";
      XF86MonBrightnessDown = "${light} set 5%-";
      XF86MonBrightnessUp = "${light} set +5%";
      "${mod}+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
      "${mod}+e" = "exec ${terminal} ranger";
    };
    input."type:keyboard" = {
      xkb_layout = "br";
      xkb_model = "abnt2";
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
    output."*" = { bg = "${wallpaper} fill"; };
    gaps.outer = 9;
    gaps.inner = 7;
    #client.focused #eb52eb #eb52eb #eb52eb #eb52eb;
    bars = [{ command = "waybar"; }];      
  };
  extraConfig = ''
    default_border pixel 3
    default_floating_border pixel 3
    client.focused #eb52eb #eb52eb #eb52eb #eb52eb
    bindsym Mod4+Control+Shift+Right move workspace to output right
    bindsym Mod4+Control+Shift+Left move workspace to output left
    bindsym Mod4+Control+Shift+Down move workspace to output down
    bindsym Mod4+Control+Shift+Up move workspace to output up
  '';
  
  extraSessionCommands = ''
    export GTK_USE_PORTAL=1 
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway
    export MOZ_ENABLE_WAYLAND=1
    export CLUTTER_BACKEND=wayland
    export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
    export QT_QPA_PLATFORM=wayland-egl
    export QT_QPA_PLATFORMTHEME=gtk3
    export ECORE_EVAS_ENGINE=wayland-egl
    export ELM_ENGINE=wayland_egl
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export NO_AT_BRIDGE=1
    export WLR_NO_HARDWARE_CURSORS=1
    export SSH_AUTH_SOCK=/run/user/1000/gnupg/S.gpg-agent.ssh
  '';
};
# export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
# export QT_QPA_PLATFORM=wayland-egl
}
