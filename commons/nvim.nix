{ config, pkgs, lib, ... }:
{
  home.packages = with pkgs; [
    unzip
    wget
    fzf
    wl-clipboard
    htop
    ripgrep
  ];

  programs.neovim = {
    enable = true;
    viAlias = false;
    vimAlias = false;
    vimdiffAlias = false;
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      nvim-treesitter.withAllGrammars
    ];
    extraConfig = lib.fileContents ../dotfiles/nvim/init.lua;
  };

  xdg.configFile.nvim = {
    source = ../dotfiles/nvim;
    recursive = true;
  };
}
