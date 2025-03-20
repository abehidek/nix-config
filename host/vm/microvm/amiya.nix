{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  modules,
  paths,
  all,
  impermanence,
  name,
  id-machine,
  mac,
  ...
}:

{
  imports = [
    (all { inherit pkgs nixpkgs paths; })
    impermanence.nixosModules.impermanence
    modules.vm.microvm.guest
  ];

  hidekxyz.vm.microvm.guest = {
    inherit mac;
    hostName = name;
    hostId = id-machine;
    memSize = 512 * 5;
    imageSize = 1024 * 8;

    persistence.dirs = [ "/var/lib/docker" ];
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 6443 ];
  };

  # For longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2025-03.com.open-iscsi:${name}";
  };

  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    stress
    htop
    lazygit
    helix
    fastfetch
  ];

  users.mutableUsers = false;
  users.users."abe" = {
    uid = 1000;
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ];
  };

  system.stateVersion = "25.05";
}
