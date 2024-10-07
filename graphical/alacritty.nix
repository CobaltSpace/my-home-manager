{ config, lib, pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/alacritty) pkgs.emptyDirectory;
    settings = {
      import = [
        "${pkgs.alacritty-theme}/catppuccin.toml"
      ];
      colors.primary.background = "#000000";
      cursor.style.blinking = "On";
      font = {
        size = 10;
        normal.family = "FantasqueSansM Nerd Font";
      };
      scrolling.history = 100000;
      window = {
        dynamic_padding = true;
        opacity = 0.7;
      };
    };
  };
}
