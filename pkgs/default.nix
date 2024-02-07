{ inputs, outputs, pkgs }: rec {
  swww = pkgs.callPackage ./swww.nix {};

  "template.lxc.aoi" = inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = [  ../systems/templates/lxc/aoi ];
    specialArgs = { inherit inputs outputs; };
    format = "proxmox-lxc";
  };
}