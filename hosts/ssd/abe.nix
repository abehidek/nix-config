{ lib, config, pkgs, unstable, user, ... }: {
  imports = [
    ../../modules/editors/neovim/home.nix
  ];
  home.packages = with pkgs; [
    # GUI Applications
    exodus
    firefox
    neofetch
    vscodium
    obsidian
    lazygit
  ];
  programs = {
    git = {
      enable = true;
      userEmail = "hidek.abe@outlook.com";
      userName = "abehidek";
    };
  };
}
