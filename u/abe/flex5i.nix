{
  # config,
  # lib,
  pkgs,
  all-users,
  nix-secrets,
  sops-nix,
  ...
}:

let
  userName = "abe";
  dotsPath = ../../d;
in
{
  imports = [
    sops-nix.homeManagerModules.sops
    (all-users {
      stateVersion = "24.11";
      inherit pkgs userName;
    })
  ];

  sops = {
    age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
    secrets = {
      "keys/ssh-abe@flex5i" = {
        path = "/home/${userName}/.ssh/id_ed25519";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "git" = {
        host = "github.com gitlab.com";
        identitiesOnly = true;
        identityFile = [ "~/.ssh/id_ed25519" ];
      };
    };
  };

  programs.nushell = {
    enable = true;
    configFile.source = dotsPath + /nushell/config.nu;

    shellAliases = {
      sysc = "sudo nixos-rebuild switch --flake";
      usrc = "home-manager switch --flake";
      l = "ls -al";
    };

    environmentVariables = {
      VISUAL = "hx";
      EDITOR = "hx";
    };

    envFile.source = dotsPath + /nushell/env.nu;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

  programs.zellij = {
    enable = true;
  };

  home.file = {
    ".ssh/id_ed25519.pub".source = ../../k/abe/flex5i.pub;
    ".config/zellij/config.kdl".source = dotsPath + /zellij/config.kdl;
  };

  home.packages = with pkgs; [
    ani-cli
    spacedrive
  ];
}
