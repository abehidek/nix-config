{
  system = import ./system.nix;

  all = {
    linux = import ./all/linux.nix;
    darwin = import ./all/darwin.nix;
  };

  develop = {
    lsp.nix = import ./develop/lsp/nix.nix;
  };

  vm.microvm.guest = import ./vm/microvm/guest.nix;

  home = {
    all = import ./home/all.nix;
    starship = import ./home/starship.nix;
    develop = {
      editor.zed = import ./home/develop/editor/zed.nix;
    };
  };
}
