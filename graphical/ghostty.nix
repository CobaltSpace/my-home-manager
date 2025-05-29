{ config, ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      font-family = "FantasqueSansM Nerd Font";
      # theme = "catppuccin-mocha";
      theme = "cyberdream";
      background = "black";
      background-opacity = 0.7;
      # font-size = 10;
      # shell-integration-features = "cursor,sudo,no-title";
    };
  };
  xdg.configFile."ghostty/themes" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.xdg.dataHome}/nvim/lazy/cyberdream.nvim/extras/ghostty";
  };
}
