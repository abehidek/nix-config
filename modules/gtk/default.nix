{ pkgs, ... }:
{
home-manager.users.abe.gtk = 
let
  theme = pkgs.nordic;
  iconTheme = pkgs.papirus-icon-theme; 
in
{
  enable = true;
  gtk3.extraConfig = { gtk-application-prefer-dark-theme=true; };
  theme.package = theme;
  theme.name = "Nordic";
  iconTheme.package = iconTheme;
  iconTheme.name = "Papirus-Dark";
};
}