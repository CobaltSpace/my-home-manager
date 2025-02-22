{ pkgs, ... }:
{
  programs.neovide = {
    enable = true;
    package = pkgs.emptyDirectory;
    settings = {
      tabs = false;
      fork = false;
    };
  };
}
