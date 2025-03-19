{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  paths,
  all,
  # disko,
  impermanence,
  microvm,
  # nixvirt,

  # id-machine,
  # id-disk,
  # name-zpool,

  # test-ubuntu,
  # opnsense,
  # irene,
  # ray,
  # sebas,
  silence,
  ...
}:

{
  imports = [ microvm.nixosModules.host ];

  # k3s postgresql and nginx
  microvm.vms."silence-01" = {
    inherit pkgs;
    config = import silence;
    specialArgs = {
      inherit nixpkgs paths all;
      impermanence = impermanence;
      name = "silence-01";
      id-machine = "eb4c010f38f7454d95d0a781a07465a2";
      mac = "00:00:00:00:00:01";
    };
  };
}
