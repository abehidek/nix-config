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
    memSize = 512 * 3;
    imageSize = 1024 * 8;

    persistence.dirs = [ "/var/lib/docker" ];
  };

  microvm.qemu =
    let
      SOCKLOCATION = "/var/lib/microvms/${name}/control.socket";
    in
    {
      extraArgs = [
        "-serial"
        "unix:${SOCKLOCATION},server,nowait"
      ];
      serialConsole = false;
    };

  boot.kernelParams = [
    "console=ttyS0,38400n8"
    "earlyprint=serial,ttyS0,38400n8"
  ];

  environment.systemPackages = with pkgs; [
    neofetch
    pfetch
    htop
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
