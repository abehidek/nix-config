{ pkgs, ... }:
{
home-manager.users.abe.gtk = 
let
  theme = pkgs.arc-theme;
  iconTheme = pkgs.papirus-icon-theme; 
in
{
  enable = true;
  theme.package = theme;
  theme.name = "Arc-Dark";
  iconTheme.package = iconTheme;
  iconTheme.name = "Papirus";
};
}