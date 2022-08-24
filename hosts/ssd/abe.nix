{ lib, config, pkgs, unstable, user, ... }: {
  imports = [
    ../../modules/editors/neovim/home.nix
  ];
  home.packages = with pkgs; [
    # GUI Applications
    exodus
    firefox
    thunderbird
    neofetch
    vscodium
    tetrio-desktop
    osu-lazer
    obsidian
  ];
}
