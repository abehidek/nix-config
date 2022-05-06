{ config, pkgs, ... }: {
  environment = {
    variables.EDITOR = "nvim";
    variables.VISUAL = "nvim";
    variables.TERM = "kitty";
  };
}
