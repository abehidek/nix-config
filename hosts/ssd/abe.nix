{ lib, config, pkgs, unstable, user, ... }: {
  imports = [
    ../../modules/editors/neovim/home.nix
  ];
  home.packages = with pkgs; [
    exodus
    obsidian
  ];
  programs = {
    git = {
      enable = true;
      userEmail = "hidek.abe@outlook.com";
      userName = "abehidek";
      extraConfig = {
        core = {
          filemode = false;
        };
        safe = {
          directory = "/shared/ws/zettelkasten";
        };
      };
    };
  };
}
