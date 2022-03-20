{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config = config.nixpkgs.config; };
in
{
  home-manager.users.abe = {
    home = {
      file = {
        ".config/nvim/settings.lua".source = ./lua/settings.lua;
        ".config/nvim/nvim-tree.lua".source = ./lua/nvim-tree.lua;
        ".config/nvim/treesitter.lua".source = ./lua/treesitter.lua;
      };
    };
    programs.neovim = {
      enable = true;
      #package = unstable.neovim-unwrapped;
      extraConfig = ''
        luafile $XDG_CONFIG_HOME/nvim/settings.lua
      '';

        # nmap <C-p> :NvimTreeToggle <CR>
        # map ; :
      plugins = with pkgs.vimPlugins; [
        #indentLine
        
        # Eyecandy
        #nvim-treesitter
        # File tree
        nvim-web-devicons 
        nvim-tree-lua
        vim-nix
      ];
    };
  };
}