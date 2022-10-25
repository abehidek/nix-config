{ lib, config, pkgs, unstable, user, ... }: {
  home.username = user;
  home.homeDirectory = "/home/${user}";
  home.packages = with pkgs; [ sl ];

  imports = [
    ../../modules/editors/neovim/home.nix
    ../../modules/editors/vim/home.nix

    ../../modules/shell/home.nix
    ../../modules/shell/zsh/home.nix
  ];
}
