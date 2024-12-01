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
      source = [
        "./hyprland.conf.d/output.conf"

        "./hyprland.conf.d/locker.conf"
        "./hyprland.conf.d/autostart.conf"

        "./hyprland.conf.d/keybinds.conf"
        "./hyprland.conf.d/windows.conf"
      ];
      env = [
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "BROWSER,firefox"
        "TERMINAL,alacritty"
        # "AMD_VULKAN_ICD,RADV"
      ];
      general = {
        gaps_out = 0;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
      };
      # decoration = { };
      # animations = { };
      input = {
        numlock_by_default = true;

        touchpad.natural_scroll = true;
      };
      gesture = {
        workspace_swipe = true;
        workspace_swipe_forever = true;
        workspace_swipe_fingers = 4;
        workspace_swipe_create_new = false;
        workspace_swipe_min_speed_to_force = 0;
        workspace_swipe_cancel_ratio = 0;
      };
      misc = {
        allow_session_lock_restore = true;
        force_default_wallpaper = 3;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      "$mainMod" = "SUPER";
      "$up" = "k";
      "$down" = "j";
      "$left" = "h";
      "$right" = "l";

      "$Locker" = "loginctl lock-session";
    };
  };
}
