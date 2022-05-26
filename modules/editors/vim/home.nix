{ lib, config, pkgs, unstable, ... }:

let colorscheme = import ../../themes/colorscheme;
in {
  programs.vim = {
    enable = true;
    extraConfig = ''
      set relativenumber
      set foldmethod=indent
      syntax enable
      set shiftwidth=2
      set tabstop=2
      set autoindent
      set expandtab
      set hlsearch
      set encoding=utf-8
      set wrap
      set clipboard=unnamedplus
      set nobackup
      let mapleader = " "
      let g:mapleader = " "
      nnoremap x "_x
      nnoremap d "_d
      nnoremap D "_D
      vnoremap d "_d

      nnoremap <leader>d ""d
      nnoremap <leader>D ""D
      vnoremap <leader>d ""d
    '';
  };
}
