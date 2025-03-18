{
  config,
  # lib,
  pkgs,
  modulesPath,
  nixpkgs,
  paths,
  all,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    (all { inherit pkgs nixpkgs paths; })
  ];

  # hardware and boot

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
  boot.extraModulePackages = [ config.boot.kernelPackages.wireguard ];
  boot.kernel.sysctl = {
    "net.ipv4.ping_group_range" = "0 1000";
  };

  # networking

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
      8080
    ];
  };

  # services programs

  virtualisation.docker.enable = true;

  programs.git.enable = true;

  environment = {
    systemPackages = with pkgs; [
      # tui
      helix
      lazygit
      # cli
      lsof
      neofetch
      htop
      # virtualisation
      docker-compose
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
      extraGroups = [
        "wheel"
        "video"
        "audio"
        "docker"
      ];
    };
  };

  system.stateVersion = "24.11";
}
