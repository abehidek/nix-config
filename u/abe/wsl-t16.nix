{
  # config,
  # lib,
  pkgs,
  all-users,
  nix-secrets,
  sops-nix,
  ...
}:

let
  userName = "abe";
in
{
  imports = [
    sops-nix.homeManagerModules.sops
    (all-users {
      stateVersion = "25.05";
      inherit pkgs userName;
    })
  ];

  sops = {
    age.keyFile = "/home/${userName}/.config/sops/age/keys.txt";
    defaultSopsFile = "${builtins.toString nix-secrets}/secrets.yaml";
    secrets = {
      "keys/ssh-abe@wsl-t16" = {
        path = "/home/${userName}/.ssh/id_ed25519";
      };
    };
  };

  home.file = {
    ".ssh/id_ed25519.pub".source = ../../k/abe/wsl-t16.pub;
  };

  home.packages = with pkgs; [];
}
