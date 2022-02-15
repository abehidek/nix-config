{ pkgs, ... }:
{
home-manager.users.abe.gtk = 
let
  theme = pkgs.nordic;
  iconTheme = pkgs.papirus-icon-theme; 
in
{
  enable = true;
  theme.package = theme;
  theme.name = "Nordic";
  iconTheme.package = iconTheme;
  iconTheme.name = "Papirus";
};
}