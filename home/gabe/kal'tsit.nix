{
  # config,
  # lib,
  pkgs,
  # paths,
  all-users,
  ...
}:

{
  imports = [
    (all-users {
      inherit pkgs;
      userName = "gabe";
      stateVersion = "25.05";
    })
  ];

  home.packages = with pkgs; [
    alacritty
    obsidian
  ];

  programs.ssh = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      dwnc = "darwin-rebuild switch --flake .#\"kal'tsit\"";
      k = "kubectl";
      l = "ls -lah";
    };
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
    ];
    userSettings."theme" = {
      "mode" = "dark";
      "dark" = "One Dark";
      "light" = "Solarized Light";
    };
  };
}
