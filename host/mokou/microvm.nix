{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  modules,
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
  silence,
  amiya,
  ...
}:

{
  imports = [ microvm.nixosModules.host ];

  microvm.vms = {
    # k3s postgresql and nginx
    "silence-01" = {
      inherit pkgs;
      config = import silence;
      specialArgs = {
        inherit nixpkgs modules paths;
        inherit all impermanence;
        name = "silence-01";
        id-machine = "eb4c010f38f7454d95d0a781a07465a2";
        mac = "00:00:00:00:00:01";
      };
    };

    "amiya-01" = {
      inherit pkgs;
      config = import amiya;
      specialArgs = {
        inherit nixpkgs modules paths;
        inherit all impermanence;
        name = "amiya-01";
        id-machine = "6033eab2137d4de386daafb31987da00";
        mac = "00:00:00:00:01:01";
      };
    };

    "amiya-02" = {
      inherit pkgs;
      config = import amiya;
      specialArgs = {
        inherit nixpkgs modules paths;
        inherit all impermanence;
        name = "amiya-02";
        id-machine = "cc3e846db49d4fc799bf5feb5ae16f68";
        mac = "00:00:00:00:01:02";
      };
    };
  };
}
