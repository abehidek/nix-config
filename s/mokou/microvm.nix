{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  all,
  impermanence,
  microvm,
  arion,
  ...
}:

{
  imports = [ microvm.nixosModules.host ];

  microvm.vms."test-mvm01" = {
    inherit pkgs;
    config = import ./vm/test-microvm.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "test-mvm01";
    };
  };

  microvm.vms."apps" = {
    inherit pkgs;
    config = import ./vm/apps.nix;
    specialArgs = {
      inherit
        nixpkgs
        all
        impermanence
        arion
        ;
      name = "apps";
    };
  };
}
