{ pkgs, inputs, outputs, lib, ... }:
let
  allUsers = [ "abe" ];
  forAllUsers = lib.genAttrs (allUsers);
in {
  imports = [
    ../global
    inputs.nixos-wsl.nixosModules.wsl
    inputs.vscode-server.nixosModule
    inputs.home-manager.nixosModules.home-manager
  ] ++ (builtins.attrValues outputs.nixosModules);

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "abe";
    startMenuLaunchers = true;
    nativeSystemd = true;
  };

  services.vscode-server.enable = true;

  modules.system = {
    shell = {
      zsh = {
        enable = true;
        users = allUsers;
        rice = true;
      };
      direnv = {
        enable = true;
        users = allUsers;
      };
    };
    services = {
      docker = {
        enable = false;
        users = allUsers;
        package = (pkgs.docker.override { iptables = pkgs.iptables-legacy; });
      };
    };
  };

  users.users = forAllUsers (user: {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" "video" "audio" ];
  });

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users = forAllUsers (user: import ./${user}.nix { inherit user; });
    extraSpecialArgs = { inherit inputs outputs; };
  };

  # Security
  # security = {
  #   sudo.enable = true;
  #   rtkit.enable = true;
  #   protectKernelImage = true;
  # };

  # Network
  networking = {
    hostName = "wsl";
  };

  # Desktop
  # services = {
  #   gnome.gnome-keyring.enable = true;
  # };

  environment.systemPackages = with pkgs; [ 
    # Handle OS keyrings
    # gnome.gnome-keyring
    # libsecret
  ];

  system.stateVersion = "22.05";
}
