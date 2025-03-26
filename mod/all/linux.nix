{
  # config,
  lib,
  pkgs,
  # modulesPath,
  # paths,
  ...
}:

{
  imports = [ ./all.nix ];

  options."hidekxyz"."all"."linux" = { };

  config = lib.mkMerge [
    {
      nix.settings.auto-optimise-store = true;
      programs.mtr.enable = true;

      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
        };
      };

      environment.systemPackages = with pkgs; [
        cmatrix
      ];
    }
  ];
}
