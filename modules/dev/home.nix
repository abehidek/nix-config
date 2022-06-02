{ lib, config, pkgs, unstable, ... }: {
  home = {
    packages = with unstable; [
      git-crypt
      virt-manager
      # eclipses.eclipse-java jetbrains.idea-community jetbrains.pycharm-community
      pkgs.beekeeper-studio
      unstable.vscodium
    ];
    sessionVariables = {
      VSCODE_GALLERY_SERVICE_URL = "https://marketplace.visualstudio.com/_apis/public/gallery";
      VSCODE_GALLERY_CACHE_URL = "https://vscode.blob.core.windows.net/gallery/index";
      VSCODE_GALLERY_ITEM_URL = "https://marketplace.visualstudio.com/items";
      VSCODE_GALLERY_CONTROL_URL="";
      VSCODE_GALLERY_RECOMMENDATIONS_URL="";
    };
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
