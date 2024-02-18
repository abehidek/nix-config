{ pkgs, inputs, outputs, lib, config, modulesPath, ... }: {
  imports = [
    ./hardware.nix
    ../global
  ];

  boot.tmp.cleanOnBoot = true;
  zramSwap.enable = true;

  networking = {
    hostName = "roxy";
    domain = "";
  };

  time.timeZone = "America/Sao_Paulo";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    vim openssl helix git lazygit
  ];

  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };

  users = {
    users.abe = {
      isNormalUser = true;
      initialPassword = "password";
      extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    };
  };

  system.stateVersion = "23.11";
}
