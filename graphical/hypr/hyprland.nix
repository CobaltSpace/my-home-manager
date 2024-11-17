{ lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/hyprland) (
      lib.makeOverridable ({ ... }: pkgs.emptyDirectory) { }
    );
    xwayland.enable = false;
    settings = {
      source = "./hyprland.conf.bak";
    };
  };
}
