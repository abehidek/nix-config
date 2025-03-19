{
  system = import ./system.nix;
  vm.microvm.guest = import ./vm/microvm/guest.nix;
}
