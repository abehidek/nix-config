{
  # config,
  # lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  proxmoxLXC = {
    privileged = true;
    manageNetwork = false;
    manageHostName = false;
  };

  boot.loader.grub.enable = false;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  programs.git.enable = true;

  programs.mtr.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    wget
    hello
  ];

  users.users = {
    root.initialPassword = "nixos";
    abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [
        "wheel"
        "video"
        "audio"
      ];
    };
  };

  system.stateVersion = "24.11";
}
