{
  # config,
  # lib,
  pkgs,
  # modulesPath,
  nixpkgs,
  all,
  impermanence,
  microvm,
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
      inherit nixpkgs all impermanence;
      name = "apps";
    };
  };

  # k3s postgresql and nginx
  microvm.vms."irene-01" = {
    inherit pkgs;
    config = import ./vm/k3s/irene-01.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "irene-01";
    };
  };

  # k3s worker
  microvm.vms."ray-01" = {
    inherit pkgs;
    config = import ./vm/k3s/ray-01.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "ray-01";
    };
  };

  # k3s server
  microvm.vms."sebas-01" = {
    inherit pkgs;
    config = import ./vm/k3s/sebas-01.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "sebas-01";
    };
  };

  microvm.vms."sebas-02" = {
    inherit pkgs;
    config = import ./vm/k3s/sebas-02.nix;
    specialArgs = {
      inherit nixpkgs all impermanence;
      name = "sebas-02";
    };
  };
}
