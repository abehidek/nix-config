{ pkgs, inputs, outputs, lib, config, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix") # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/git.nix
    ../global
  ];

  proxmoxLXC = {
    privileged = false;
    manageNetwork = false;
    manageHostName = false;
  };

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  boot.loader.grub.enable = false;
  boot.kernel.sysctl = {
    "net.ipv4.ping_group_range" = "0 1000";
  };

  networking= {
    firewall = {
      enable = false;
      allowedTCPPorts = [ 80 443 8080 3000 ];
    };
  };


  virtualisation = {
    docker = {
      enable = true;
      package = pkgs.docker;
    };
    podman = {
      enable = true;
      # Create docker alias for podman and use as replacement
      dockerCompat = false;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  programs = {
    git.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # tui
      helix lazygit
      # cli
      lsof neofetch htop
      # virtualisation
      docker-compose
      podman-compose
    ];

    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };
  };

  users.users = {
    root.initialPassword = "nixos";
    abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" "video" "audio" "docker" "podman" ];
    };
  };

  system.stateVersion = lib.version;
}
