{
  config,
  lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  home-manager,
  # nur,
  all,
  all-users,
  nix-secrets,
  sops-nix,
  nixos-wsl,
  ...
}:

{
  imports = [
    home-manager.nixosModules.home-manager
    (all { inherit pkgs nixpkgs; })
    sops-nix.nixosModules.sops
    nixos-wsl.nixosModules.default
  ];

  sops = {
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
    validateSopsFiles = false;
    age = {
      # sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = false;
      keyFile = "/home/abe/.config/sops/age/keys.txt";
    };

    secrets = {
      "keys/ssh-abe@wsl-t16" = {
        path = "/root/.ssh/id_ed25519"; # private repo access on "sudo nixos-rebuild switch" bc sudo runs w/ sudo user
      };
    };
  };

  wsl = {
    enable = true;
    defaultUser = "abe";
  };

  networking.hostName = "wsl-t16";

  /*
    Since WSL creates an entire virtual LAN on the host machine,
    we need to assign a different port too the OpenSSH service,
    which is 2022 as you can see below
    This happens because the host machine also has SSH which listens
    to the same port, so to avoid conflict we assign a different port

    After this, get the WSL VLAN IP
    $ wsl hostname -I

    Then on the host powershell run:
    $ New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd) for WSL' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 2022

    $ netsh interface portproxy add v4tov4 listenport=2022 listenaddress=0.0.0.0 connectport=2022 connectaddress=<WSL_VLAN_IP>

    Get the host LAN IP:
    $ ipconfig

    Then simply connect to WSL using
    $ ssh <user>@<HOST_LAN_IP> -p 2022
  */
  services.openssh.ports = [ 2022 ];

  programs.nix-ld = {
    enable = true;
    package = pkgs.nix-ld-rs; # only for NixOS 24.05
  };

  environment.sessionVariables = {
    VISUAL = "hx";
    EDITOR = "hx";
  };

  environment.systemPackages = with pkgs; [
    wget
    git
    helix
    lazygit
    age
    sops

    pfetch
    neofetch
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.extraSpecialArgs = {
    inherit all-users nix-secrets sops-nix;
  };

  home-manager.users.abe = import ../../u/abe/${config.networking.hostName}.nix;

  system.stateVersion = "24.05";
}
