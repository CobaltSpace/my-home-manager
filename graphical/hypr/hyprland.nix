{ lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/hyprland) (
      lib.makeOverridable ({ ... }: pkgs.emptyDirectory) { }
    );
    importantPrefixes = [
      "$"
      "bezier"
      "env"
      "name"
      "source"
    ];
    settings = {
      env = [
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "BROWSER,firefox"
        "TERMINAL,alacritty"
      ];
      general = {
        gaps_out = 0;
        border_size = 2;
        col = {
          active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          inactive_border = "rgba(595959aa)";
        };
      };
      input = {
        numlock_by_default = true;

        touchpad.natural_scroll = true;
      };
      source = [ "./hyprland.conf.bak" ];
    };
  };
}
