{ lib, config, pkgs, unstable, ... }: {
  home = {
    packages = with unstable; [
      git-crypt
      # eclipses.eclipse-java jetbrains.idea-community jetbrains.pycharm-community
      pkgs.beekeeper-studio
      unstable.vscodium
    ];
  };
  programs = {
    direnv.enable = true;
    git = {
      enable = true;
      userName = "abehidek";
      userEmail = "hidek.abe@outlook.com";
      extraConfig = { init = { defaultBranch = "main"; }; };
    };
    gh = { enable = true; };
    gpg = { enable = true; };
  };
}
