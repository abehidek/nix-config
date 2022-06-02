{ lib, config, pkgs, unstable, ... }: {
  # services = {
  # mysql.enable = true;
  # mysql.package = pkgs.mysql80;
  # };
  #virtualisation.virtualbox.host.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.libvirtd.onBoot = "ignore";
  programs.dconf.enable = true;
  users.extraGroups.vboxusers.members = [ "abe" ];
  services.lorri.enable = true;
  services.lorri.package = unstable.lorri;
  services.mongodb = {
    enable = true;
  };

  environment = { systemPackages = with pkgs; [ mongodb-compass insomnia ]; };
}
