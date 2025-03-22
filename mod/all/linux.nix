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

      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };

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
