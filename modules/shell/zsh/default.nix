{ lib, config, pkgs, ... }: {
  environment = { systemPackages = with pkgs; [ any-nix-shell ]; };
  users.defaultUserShell = pkgs.zsh;
}
