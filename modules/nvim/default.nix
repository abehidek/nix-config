{ config, pkgs, ... }:
let
  colorscheme = import ../theme/colorscheme;
  unstable = import (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz) { config = config.nixpkgs.config; };
  telescope-media-files-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "telescope-media-files-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "nvim-telescope";
      repo = "telescope-media-files.nvim";
      rev = "master";
      sha256 = "1ap3ijh64ynyxzbc62ijfkbwasv506i17pc65bh3w4dfpzn6rlpy";
    };
  };
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
        ".config/nvim/plugins/toggleterm.lua".source = ./lua/plugins/toggleterm.lua;
        ".config/nvim/plugins/bufferline.lua".source = ./lua/plugins/bufferline.lua;
      };     
      sessionVariables = {
        JAVALSP = "${unstable.java-language-server}";
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
      # -- theme and appearance
        indent-blankline-nvim
        nord-nvim
        vimade
        vim-startify
        # -- air line
          vim-airline
          vim-airline-clock
          vim-airline-themes
      # -- utils
        vim-rooter
        markdown-preview-nvim
        direnv-vim
        toggleterm-nvim
        # -- telescope
          telescope-nvim
          telescope-media-files-nvim
        # -- buffers
          bufferline-nvim
          vim-bbye
        # -- tree
          nvim-tree-lua
          nvim-web-devicons
        # --git
          lazygit-nvim
          vim-signify
      # -- language support
        # -- cmp and lsp
          nvim-cmp
          cmp-buffer
          cmp-path
          cmp-cmdline
          cmp_luasnip
          vim-lsc
          nvim-lspconfig
          cmp-nvim-lsp
        # -- dap
          nvim-dap
          telescope-dap-nvim
        # -- highlighting
          nvim-treesitter
          # vim-polyglot
        # -- snippets
          luasnip
          friendly-snippets
        # -- languages
          # vim-elixir
          vim-nix
          vim-javascript
          # haskell-vim
          dart-vim-plugin
          vim-flutter
          # rust-vim
      ];
      extraPackages = with unstable; [
        ueberzug ripgrep
        nodePackages.pyright
        sumneko-lua-language-server
        # nodePackages.typescript-language-server
        nodePackages.typescript
        nodePackages.typescript-language-server
        # nodePackages.eslint
        # nodePackages.vscode-langservers-extracted
        # yarn flow
        # pkgs.nodePackages.stylelint
        rust-analyzer
        rnix-lsp
        haskell-language-server
        java-language-server
        nodePackages.vue-language-server
        clang
      ];
      extraConfig = ''
        luafile $XDG_CONFIG_HOME/nvim/settings.lua
      '';
    };
  };
}

