{
  all = {
    linux = import ./all/linux.nix;
    darwin = import ./all/darwin.nix;
  };
  system = import ./system.nix;
  develop.lsp.nix = import ./develop/lsp/nix.nix;
  vm.microvm.guest = import ./vm/microvm/guest.nix;
}
