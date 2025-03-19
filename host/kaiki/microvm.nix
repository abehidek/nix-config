{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  modules,
  paths,
  # nixos-hardware,
  all,
  # nix-secrets,
  # sops-nix,
  impermanence,
  microvm,
  suzuki,
  ...
}:

{
  imports = [ microvm.nixosModules.host ];

  # k3s worker
  microvm.vms."suzuki-01" = {
    inherit pkgs;
    config = import suzuki;
    specialArgs = {
      inherit nixpkgs modules paths;
      inherit all impermanence;
      name = "suzuki-01";
      id-machine = "423a2be1f1b04f03ae4f5be8f7fddf84";
      mac = "12:cd:c8:46:ef:dc";
    };
  };
}
