{
  # config,
  lib,
  # pkgs,
  # modulesPath,
  ...
}:

{
  options."hidekxyz"."home"."starship" = { };

  config = lib.mkMerge [
    {
      programs.starship = {
        enable = true;
        enableZshIntegration = true;
        enableNushellIntegration = true;
        settings = {
          character = {
            success_symbol = "[λ](bold green)";
            error_symbol = "[λ](bold red)";
          };
          shell = {
            disabled = false;
            bash_indicator = "$";
            zsh_indicator = "z";
            nu_indicator = "nu";
            fish_indicator = "󰈺 ";
            powershell_indicator = "_";
            unknown_indicator = "?";
            style = "cyan bold";
          };
        };
      };
    }
  ];
}
