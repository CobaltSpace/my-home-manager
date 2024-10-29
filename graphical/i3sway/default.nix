{ lib, ... }:
let
  modifier = "Mod4";
  left = "h";
  down = "j";
  up = "k";
  right = "l";
  mode_system = "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";
  workspaces = {
    "1" = "1:一";
    "2" = "2:二";
    "3" = "3:三";
    "4" = "4:四";
    "5" = "5:五";
    "6" = "6:六";
    "7" = "7:七";
    "8" = "8:八";
    "9" = "9:九";
    "0" = "10:十";
    minus = "11:";
    equal = "12:";
  };
  i3sway = {
    config = {
      inherit
        modifier
        left
        down
        up
        right
        ;
      window.titlebar = false;
      floating.titlebar = false;
      gaps = {
        smartGaps = true;
        smartBorders = "on";
        inner = 5;
      };
      defaultWorkspace = "workspace number ${workspaces."1"}";
      keybindings = lib.attrsets.mergeAttrsList [
        {
          # Move your focus around
          "${modifier}+${left}" = "focus left";
          "${modifier}+${right}" = "focus right";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${down}" = "focus down";
          "${modifier}+bracketleft" = "focus output left";
          "${modifier}+bracketright" = "focus output right";

          # Move the focused window with the same, but add Shift
          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${right}" = "move right";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+braceleft" = "move output left";
          "${modifier}+braceright" = "move output right";

          "${modifier}+Ctrl+bracketleft" = "move workspace output left";
          "${modifier}+Ctrl+bracketright" = "move workspace output right";

          # You can "split" the current object of your focus with
          # $mod+b or $mod+v, for horizontal and vertical splits respectively
          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";

          # Make the current focus fullscreen
          "${modifier}+f" = "fullscreen enable";

          # Toggle the current focus between tiling and floating mode
          "${modifier}+s" = "floating enable; fullscreen disable";
          "${modifier}+t" = "floating disable; fullscreen disable";

          # Move focus to the parent container
          "${modifier}+a" = "focus parent";

          # show the next scratchpad window or hide the focused scratchpad window.
          # if there are multiple scratchpad windows, this command cycles through them.
          "${modifier}+grave" = "scratchpad show";

          # move the currently focused window to the scratchpad
          "${modifier}+Shift+grave" = "move scratchpad";

          # Resize containers
          "Mod1+Mod4+${left}" = "resize grow width";
          "Mod1+Mod4+${down}" = "resize grow height";
          "Mod1+Mod4+${up}" = "resize grow height";
          "Mod1+Mod4+${right}" = "resize grow width";

          "Mod1+Mod4+Shift+${left}" = "resize shrink width";
          "Mod1+Mod4+Shift+${down}" = "resize shrink height";
          "Mod1+Mod4+Shift+${up}" = "resize shrink height";
          "Mod1+Mod4+Shift+${right}" = "resize shrink width";

          "Mod1+Mod4+Home" = "resize set 1920";
          "Mod1+Mod4+End" = "resize set 1600";
          "${modifier}+Ctrl+Home" = "resize set height 1080";
          "${modifier}+Ctrl+End" = "resize set height 900";
          "Mod1+Mod4+Ctrl+Home" = "resize set 1920 1080";
          "Mod1+Mod4+Ctrl+End" = "resize set 1600 900";

          "Mod1+Mod4+q" = ''mode "${mode_system}"'';

          "--locked XF86AudioRaiseVolume" = "exec --no-startup-id amixer -D pulse sset Master 2%+ unmute"; # increase sound volume
          "--locked XF86AudioLowerVolume" = "exec --no-startup-id amixer -D pulse sset Master 2%-"; # decrease sound volume
          "--locked XF86AudioMute" = "exec --no-startup-id amixer -D pulse sset Master toggle"; # mute sound

          "--locked XF86MonBrightnessUp" = "exec brightnessctl s 5%+"; # increase screen brightness
          "--locked XF86MonBrightnessDown" = "exec brightnessctl s 5%-"; # decrease screen brightness
          "--locked ${modifier}+F12" = "exec mkdir /tmp/ddcutil && ddcutil setvcp 10 + 5 && rmdir /tmp/ddcutil"; # increase screen brightness
          "--locked ${modifier}+F11" = "exec mkdir /tmp/ddcutil && ddcutil setvcp 10 - 5 && rmdir /tmp/ddcutil"; # decrease screen brightness

          "--locked XF86AudioPlay" = "exec playerctl play-pause -i firefox || xdotool search --class itunes.exe key XF86AudioPlay";
          "--locked XF86AudioPause" = "exec playerctl pause      -i firefox || xdotool search --class itunes.exe key XF86AudioPause";
          "--locked XF86AudioNext" = "exec playerctl next       -i firefox || xdotool search --class itunes.exe key XF86AudioNext";
          "--locked XF86AudioPrev" = "exec playerctl previous   -i firefox || xdotool search --class itunes.exe key XF86AudioPrev";
        }
        (lib.attrsets.concatMapAttrs (name: value: {
          # Switch to workspace
          "${modifier}+${name}" = "workspace number ${value}";
          # Move focused container to workspace
          "${modifier}+Shift+${name}" = "move container to workspace number ${value}";
        }) workspaces)
      ];
      startup = [ { command = "autotiling"; } ];
      modes = {
        "${mode_system}" = {
          l = ''exec --no-startup-id $Locker,             mode "default"'';
          e = "exit";
          s = ''exec --no-startup-id systemctl suspend,   mode "default"'';
          h = ''exec --no-startup-id systemctl hibernate, mode "default"'';
          r = "exec --no-startup-id reboot";
          "Shift+s" = "exec --no-startup-id shutdown now";

          Return = ''mode "default"'';
          Escape = ''mode "default"'';
        };
      };
    };
  };
in
{
  imports = [ ./sway.nix ];

  wayland.windowManager.sway = i3sway;
  xsession.windowManager.i3 = i3sway;
}
