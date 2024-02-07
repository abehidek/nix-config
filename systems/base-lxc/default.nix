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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8080 ];
  };

  # services.getty.autologinUser = lib.mkDefault "root";

  programs = {
    git.enable = true;
  };

  environment = {
    variables = {
      EDITOR = "hx";
      VISUAL = "hx";
    };

    systemPackages = with pkgs; [
      # tui
      helix lazygit
      # cli
      lsof neofetch
    ];
  };

  users.users = {
    root.initialPassword = "nixos";
    abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" "video" "audio" ];
    };
  };

  system.stateVersion = lib.version;
}
