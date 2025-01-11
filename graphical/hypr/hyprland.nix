{ lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/hyprland) (
      lib.makeOverridable ({ ... }: pkgs.emptyDirectory) { }
    );
    systemd.enable = false;
    importantPrefixes = [
      "$"
      "bezier"
      "env"
      "name"
      "source"
    ];
    settings = {
      source = [
        "./hyprland.conf.d/locker.conf"

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
      device = [
        {
          name = "wlxoverlay-s-keyboard-mouse-hybrid-thing-1";
          natural_scroll = true;
        }
        {
          name = "epic-mouse-v1";
          sensitivity = -0.5;
        }
      ];
      gestures = {
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
      bind = [
      ];
      bindl = [
        ", XF86MonBrightnessUp  , exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        " SHIFT, XF86MonBrightnessUp  , exec, brightnessctl s 1%+"
        " SHIFT, XF86MonBrightnessDown, exec, brightnessctl s 1%-"
      ];
      exec-once = [
        "hyprctl setcursor CG 24"

        "swaync"

        "dex -ae hyprland"

        # "until waybar; do done"
        "waybar"

        # "swayidle"
        "hypridle"

        # "systemctl --user stop xdg-desktop-portal-gtk.service"
        # "systemctl --user stop xdg-desktop-portal-gnome.service"

        ''wl-paste -t text -w sh -c '[ "$(xclip -selection clipboard -o)" = "$(wl-paste -n)" ] || xclip -selection clipboard' ''
        # "wl-paste -t text -w sh -c 'xclip -selection clipboard -o < /dev/null > /dev/null 2> /dev/null || xclip -selection clipboard'"

        "../acpid.sh"
      ];
    };
  };
}
