{ pkgs, inputs, outputs, lib, config, modulesPath, ...}:

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix") # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/programs/git.nix
    ../../../global
  ];

  proxmoxLXC = {
    privileged = true;
    manageNetwork = false;
    manageHostName = false;
  };

  boot.loader.grub.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 8080 ];
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
      extraGroups = [ "wheel" "video" "audio" ];
    };
  };

  system.stateVersion = lib.version;
}
