{ lib, config, pkgs, unstable, user, ... }: {
  home.packages = with pkgs; [
    # GUI Applications
    exodus
    firefox
    thunderbird
    neofetch
    vscodium
  ];
}