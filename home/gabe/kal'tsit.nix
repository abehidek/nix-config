{
  # config,
  # lib,
  pkgs,
  paths,
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

  programs.ssh.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      dwnc = "darwin-rebuild switch --flake .#\"kal'tsit\"";
      k = "kubectl";
      l = "ls -lah";
    };
  };

  programs.nushell = {
    enable = true;
    configFile.source = (paths.dots "nushell/config.nu");
    envFile.text = ''
      mkdir ~/.cache/starship
      ${pkgs.starship}/bin/starship init nu | save -f ~/.cache/starship/init.nu
    '';

    shellAliases = {
      sysc = "sudo nixos-rebuild switch --flake .#$\"(hostname)\"";
      usrc = "home-manager switch --flake .#$\"(whoami)\"@$\"(hostname)\"";
      dwnc = "darwin-rebuild switch --flake .#\"kal'tsit\"";
      l = "ls -al";
      k = "kubectl";
    };

    environmentVariables = {
      VISUAL = "hx";
      EDITOR = "hx";
    };
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = false; # not necessarily I want to open zellij when opening zsh
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal.family = "FiraCode Nerd Font";
        size = 14;
      };
      terminal.shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [
          "-c"
          "zellij options --default-shell ${pkgs.nushell}/bin/nu"
        ];
      };
    };
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "toml"
    ];
    userSettings = {
      "terminal"."font_family" = "FiraCode Nerd Font";
      "theme" = {
        "mode" = "dark";
        "dark" = "One Dark";
        "light" = "Solarized Light";
      };
    };
  };

  home.file = {
    ".config/zellij/config.kdl".source = paths.dots "zellij/config.kdl";
  };

  home.packages = with pkgs; [
    obsidian
  ];
}
