{ pkgs, ... }:
let
  theme = pkgs.gruvbox-dark-gtk;
  iconTheme = pkgs.gruvbox-dark-icons-gtk;
in {
  gtk = {
    enable = true;
    gtk3.extraConfig = { gtk-application-prefer-dark-theme = true; };
    theme.package = theme;
    theme.name = "gruvbox-dark";
    iconTheme.package = iconTheme;
    iconTheme.name = "gruvbox-dark";
  };
}
