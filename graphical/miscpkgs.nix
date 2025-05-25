{ config, pkgs, ... }:
{
  home.packages =
    with pkgs;
    builtins.map (pkg: config.lib.nixGL.wrap pkg) [
      keybase-gui
      alcom

      # obs-studio-plugins.obs-vkcapture

      unigine-heaven
      unigine-valley
      unigine-superposition
    ];
}
