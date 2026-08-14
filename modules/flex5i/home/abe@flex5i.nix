{ inputs, self, ... }:

{
  flake.modules.homeManager."abe@flex5i" =
    { pkgs, ... }:
    let
      userName = "abe";
    in
    {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      home = {
        username = userName;
        stateVersion = "24.11";
        homeDirectory = if pkgs.stdenv.isDarwin then "/Users/${userName}" else "/home/${userName}";

        packages = with pkgs; [
          ani-cli
          home-manager
          github-cli
        ];
      };

      sops = {
        age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
        defaultSopsFile = "${toString inputs.nix-secrets}/secrets.yaml";
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

          /*
            automatically using port 2022 when connecting to this host,
            useful when building on a machine for another machine
          */
          "wsl-t16" = {
            host = "10.0.0.87";
            identitiesOnly = true;
            identityFile = [ "~/.ssh/id_ed25519" ];
            port = 2022;
          };
        };
      };

      dconf.settings."org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu+ssh://abe@10.0.0.100/system" ];
        uris = [ "qemu+ssh://abe@10.0.0.100/system" ];
      };

      programs.nushell = {
        enable = true;
        configFile.source = "${self}/dots/nushell/config.nu";

        shellAliases = {
          sysc = "sudo nixos-rebuild switch --flake .#$\"(hostname)\"";
          usrc = "home-manager switch --flake .#$\"(whoami)\"@$\"(hostname)\"";
          l = "ls -al";
          k = "kubectl";
        };

        environmentVariables = {
          VISUAL = "hx";
          EDITOR = "hx";
        };

        envFile.source = "${self}/dots/nushell/env.nu";
      };

      programs.starship = {
        enable = true;
        enableBashIntegration = true;
      };

      programs.zellij = {
        enable = true;
      };

      programs.feh = {
        enable = true;
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

      home.file = {
        ".ssh/id_ed25519.pub".source = "${self}/keys/abe@flex5i.pub";
        ".config/zellij/config.kdl".source = "${self}/dots/zellij/config.kdl";
      };
    };
}
