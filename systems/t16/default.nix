{ lib, pkgs, config, inputs, outputs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/minimal.nix"

    inputs.nixos-wsl.nixosModules.wsl
    inputs.home-manager.nixosModules.home-manager
  ];

  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "abe";
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker.enable = true;
  };

  networking.hostName = "t16-wsl";

  environment.systemPackages = with pkgs; [ cachix neofetch git wget ];

  # Enable nix flakes
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" "abe" ];
  };

  users.users."abe" = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = ["wheel" "video" "audio"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."abe" = import ./abe.nix;
    extraSpecialArgs = { inherit inputs outputs; };
  };

  system.stateVersion = "21.11";
}
