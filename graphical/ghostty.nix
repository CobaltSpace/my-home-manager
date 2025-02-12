{ ... }:
{
  programs.ghostty = {
    enable = true;
    package = null;
    settings = {
      font-family = "FantasqueSansM Nerd Font";
      theme = "catppuccin-mocha";
      background = "black";
      background-opacity = 0.7;
      # font-size = 10;
    };
    enableZshIntegration = true;
  };
}
