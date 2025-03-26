{
  # config,
  # lib,
  pkgs,
  modules,
  paths,
  hostName,
  ...
}:

{
  imports = [
    modules.home.all
    modules.home.develop.editor.zed
  ];

  hidekxyz.home = {
    all = {
      userName = "gabe";
      stateVersion = "25.05";
    };

    develop.editor.zed.shell.program = "${pkgs.nushell}/bin/nu";
  };

  home = {
    file = {
      ".config/zellij/config.kdl".source = paths.dots "zellij/config.kdl";
    };

    packages = with pkgs; [
      obsidian
      telegram-desktop
    ];
  };

  programs.ssh.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      dwnc = "darwin-rebuild switch --flake .#\"${hostName}\"";
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
      usrc = "home-manager switch --flake .#$\"(whoami)\"@\"${hostName}\"";
      dwnc = "darwin-rebuild switch --flake .#\"${hostName}\"";
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
    enableZshIntegration = true;
    enableNushellIntegration = true;
    settings = {
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol = "[λ](bold red)";
      };
      shell = {
        disabled = false;
        bash_indicator = "$";
        zsh_indicator = "z";
        nu_indicator = "nu";
        fish_indicator = "󰈺 ";
        powershell_indicator = "_";
        unknown_indicator = "?";
        style = "cyan bold";
      };
    };
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
          "${pkgs.zellij}/bin/zellij"
        ];
      };
    };
  };

  programs.vscode.enable = true;
}
