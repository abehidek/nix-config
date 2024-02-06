{ inputs, outputs, pkgs }: {
  swww = pkgs.callPackage ./swww.nix {};
  base-lxc = inputs.nixos-generators.nixosGenerate {
    system = "x86_64-linux";
    modules = [  ../systems/base-lxc ];
    specialArgs = { inherit inputs outputs; };
    format = "proxmox-lxc";
  };
}