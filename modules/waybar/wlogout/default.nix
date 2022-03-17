{ config, pkgs, ... }:
let
  colorscheme = import ../../theme/colorscheme;
in {
  home-manager.users.abe = {
    home = {
      file = {
        ".config/wlogout/layout".text = ''
          {
              "label" : "lock",
              "action" : "${pkgs.swaylock-fancy}/bin/swaylock-fancy",
              "text" : "Lock",
              "keybind" : "l"
          }
          {
              "label" : "hibernate",
              "action" : "systemctl hibernate",
              "text" : "Hibernate",
              "keybind" : "h"
          }
          {
              "label" : "logout",
              "action" : "loginctl terminate-user $USER",
              "text" : "Logout",
              "keybind" : "e"
          }
          {
              "label" : "shutdown",
              "action" : "systemctl poweroff",
              "text" : "Shutdown",
              "keybind" : "s"
          }
          {
              "label" : "suspend",
              "action" : "systemctl suspend",
              "text" : "Suspend",
              "keybind" : "u"
          }
          {
              "label" : "reboot",
              "action" : "systemctl reboot",
              "text" : "Reboot",
              "keybind" : "r"
          }
        '';
        ".config/wlogout/style.css".text = ''
          * {
            background-image: none;
          }
          window {
            background-color: rgba(12, 12, 12, 0.1);
          }
          button {
            color: #FFFFFF;
            background-color: #1E1E1E;
            border-style: solid;
            border-width: 2px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 25%;
          }

          button:focus, button:active, button:hover {
            background-color: ${colorscheme.base08};
            /* background-color: #3700B3; */
            outline-style: none;
          }

          #lock {
              background-image: image(url("/nix/store/f0mk0sbag96pq0q9pf6df9z0dz656gkv-wlogout-1.1.1/share/wlogout/icons/lock.png"), url("/usr/local/share/wlogout/icons/lock.png"));
          }

          #logout {
              background-image: image(url("/nix/store/f0mk0sbag96pq0q9pf6df9z0dz656gkv-wlogout-1.1.1/share/wlogout/icons/logout.png"), url("/usr/local/share/wlogout/icons/logout.png"));
          }

          #suspend {
              background-image: image(url("/nix/store/f0mk0sbag96pq0q9pf6df9z0dz656gkv-wlogout-1.1.1/share/wlogout/icons/suspend.png"), url("/usr/local/share/wlogout/icons/suspend.png"));
          }

          #hibernate {
              background-image: image(url("/nix/store/f0mk0sbag96pq0q9pf6df9z0dz656gkv-wlogout-1.1.1/share/wlogout/icons/hibernate.png"), url("/usr/local/share/wlogout/icons/hibernate.png"));
          }

          #shutdown {
              background-image: image(url("/nix/store/f0mk0sbag96pq0q9pf6df9z0dz656gkv-wlogout-1.1.1/share/wlogout/icons/shutdown.png"), url("/usr/local/share/wlogout/icons/shutdown.png"));
          }

          #reboot {
              background-image: image(url("/nix/store/f0mk0sbag96pq0q9pf6df9z0dz656gkv-wlogout-1.1.1/share/wlogout/icons/reboot.png"), url("/usr/local/share/wlogout/icons/reboot.png"));
          }        
        '';
      };
    };
  };
}