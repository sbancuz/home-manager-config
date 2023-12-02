{ config, pkgs, lib, ... }:
{
  # programs.git = {
  #   package = pkgs.gitAndTools.gitFull;
  #   enable = true;
  #   userName = "sbancuz";
  #   userEmail = "sbancuz@protonmail.com";
  #   aliases = {
  #     undo = "reset HEAD~1 --mixed";
  #     amend = "commit -a --amend";
  #     prv = "!gh pr view";
  #     prc = "!gh pr create";
  #     prs = "!gh pr status";
  #     prm = "!gh pr merge -d";
  #   };
  #   extraConfig = {
  #     color = {
  #       ui = "auto";
  #     };
  #     diff = {
  #       tool = "vimdiff";
  #       mnemonicprefix = true;
  #     };
  #     merge = {
  #       tool = "splice";
  #     };
  #     push = {
  #       default = "simple";
  #     };
  #     pull = {
  #       rebase = true;
  #     };
  #   };
  # };
}
