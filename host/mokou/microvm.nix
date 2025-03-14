{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  paths,
  all,
  impermanence,
  microvm,
  ...
}:

{
  imports = [ microvm.nixosModules.host ];

  # k3s postgresql and nginx
  microvm.vms."irene-01" = {
    inherit pkgs;
    config = import ./vm/irene.nix;
    specialArgs = {
      inherit nixpkgs paths all;
      impermanence = impermanence;
      name = "irene-01";
      machineId = "9fcd46289ccf4ad0b16a048223c6ba2d";
      macAddress = "02:00:00:00:00:03";
    };
  };

  # k3s worker
  microvm.vms."ray-01" = {
    inherit pkgs;
    config = import ./vm/ray.nix;
    specialArgs = {
      inherit nixpkgs paths all;
      impermanence = impermanence;
      name = "ray-01";
      machineId = "9fcd46289ccf4ad0b16a048223c6ba2d";
      macAddress = "b8:ae:cc:cf:71:c0";
    };
  };

  microvm.vms."ray-02" = {
    inherit pkgs;
    config = import ./vm/ray.nix;
    specialArgs = {
      inherit nixpkgs paths all;
      impermanence = impermanence;
      name = "ray-02";
      machineId = "a72f6995c69f4408a926493563bb3930";
      macAddress = "b8:ae:cc:cf:71:c1";
    };
  };

  # k3s server
  microvm.vms."sebas-01" = {
    inherit pkgs;
    config = import ./vm/sebas.nix;
    specialArgs = {
      inherit nixpkgs paths all;
      impermanence = impermanence;
      name = "sebas-01";
      machineId = "9fcd46289ccf4ad0b16a048223c6ba2d";
      macAddress = "02:00:00:00:00:05";
    };
  };

  microvm.vms."sebas-02" = {
    inherit pkgs;
    config = import ./vm/sebas.nix;
    specialArgs = {
      inherit nixpkgs paths all;
      impermanence = impermanence;
      name = "sebas-02";
      machineId = "dbf5a869396146c9b03dd56f0d8af0d3";
      macAddress = "02:00:00:00:00:06";
    };
  };
}
