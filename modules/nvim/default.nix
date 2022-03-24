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
        ".config/nvim/keymaps.lua".source = ./lua/keymaps.lua;
        ".config/nvim/plugins/nvim-tree.lua".source = ./lua/plugins/nvim-tree.lua;
        ".config/nvim/plugins/telescope.lua".source = ./lua/plugins/telescope.lua;
        ".config/nvim/plugins/cmp.lua".source = ./lua/plugins/cmp.lua;
        # ".config/nvim/treesitter.lua".source = ./lua/treesitter.lua;
      };      
    };
    programs.neovim = {
      enable = true;
      package = unstable.neovim-unwrapped;
      vimAlias = true;
      viAlias = true;
      withRuby = true;
      withNodeJs = true;
      withPython3 = true;
      plugins = with unstable.vimPlugins; [
        indent-blankline-nvim
        toggleterm-nvim

        # theme
        nord-nvim
        vimade
        vim-startify

        # air line
        vim-airline
        vim-airline-clock
        vim-airline-themes

        # Tree
        # nerdtree
        # nerdtree-git-plugin
        nvim-tree-lua
        nvim-web-devicons
        
        # git
        lazygit-nvim
        vim-signify

        # utils
        telescope-nvim
        vim-polyglot
        markdown-preview-nvim
        direnv-vim

        # cmp and lsp
        nvim-cmp
        cmp-buffer
        cmp-path
        cmp-cmdline
        cmp_luasnip

        nvim-lspconfig
        cmp-nvim-lsp

        # snippets
        luasnip
        friendly-snippets

        # langs
        vim-elixir
        vim-nix
        vim-javascript
        haskell-vim
        dart-vim-plugin
        vim-flutter
        rust-vim
      ];
      extraPackages = with unstable; [
        nodePackages.pyright
        sumneko-lua-language-server
        nodePackages.typescript-language-server
        rust-analyzer
        rnix-lsp
      ];
      extraConfig = ''
        luafile $XDG_CONFIG_HOME/nvim/settings.lua
      '';
    };
  };
}