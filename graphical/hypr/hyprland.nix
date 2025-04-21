{ lib, pkgs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/hyprland) (
      lib.makeOverridable (
        { ... }:
        pkgs.runCommandLocal "system-hyprctl" { } ''
          mkdir -p $out/bin
          ln -s /usr/bin/hyprctl $out/bin/
        ''
      ) { }
    );
    portalPackage = lib.mkIf (builtins.pathExists /usr/lib/xdg-desktop-portal-hyprland) null;
    systemd.enable = false;
    importantPrefixes = [
      "$"
      "bezier"
      "env"
      "name"
      "source"
    ];
    settings = {
      source = [ "./experimental.conf" ];
      env = [
        "_JAVA_AWT_WM_NONREPARENTING,1"
        "QT_QPA_PLATFORMTHEME,gtk3"
        "BROWSER,firefox"
        "TERMINAL,ghostty"
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
          natural_scroll = false;
        }
        # {
        #   name = "epic-mouse-v1";
        #   sensitivity = -0.5;
        # }
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
        vrr = true;
        enable_swallow = true;
        swallow_regex = lib.strings.concatStringsSep "|" [
          ''^Alacritty$''
          ''^com\.mitchellh\.ghostty$''
        ];
        swallow_exception_regex = lib.strings.concatStringsSep "|" [
          ''.*wev.*''
          ''.*mpv-bg$''
        ];
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };
      exec-once = [
        # "hyprctl setcursor CG 37"
        "hyprctl setcursor capitaine-cursors 24"

        "if uwsm check is-active; then uwsm app -- swaync; else swaync; fi"

        "uwsm check is-active || dex -ae hyprland"

        # "until waybar; do done"
        "waybar"
        # "uwsm app -- waybar"
        # "ashell"

        # "swayidle"
        "hypridle"

        "if ! uwsm check is-active; then systemctl --user restart xdg-desktop-portal-gtk.service && systemctl --user restart xdg-desktop-portal.service; fi"

        "systemctl --user start hyprpolkitagent.service"

        "hyprpm reload"

        # ''wl-paste -t text -w sh -c '[ "$(xclip -selection clipboard -o)" = "$(wl-paste -n)" ] || xclip -selection clipboard' ''
        # "wl-paste -t text -w sh -c 'xclip -selection clipboard -o < /dev/null > /dev/null 2> /dev/null || xclip -selection clipboard'"

        # "../acpid.sh"
        # ''systemd-inhibit --who="Hyprland config" --why="wlogout keybind" --what=handle-power-key --mode=block sleep infinity & echo $! > $XDG_RUNTIME_DIR/hypr/systemd-inhibit''
        ''systemd-inhibit --who="Hyprland config" --why="wlogout keybind" --what=handle-power-key --mode=block sleep infinity''
      ];
      # exec-shutdown = [ ''kill "$(cat $XDG_RUNTIME_DIR/hypr/systemd-inhibit)"'' ];
      windowrule = [
        ''noborder,                            floating:0,                  onworkspace:w[tv1]''
        # ''rounding 3,                        class:^itunes.exe$''
        # ''tile,                              class:^itunes.exe$,          title:^iTunes$''
        # ''nofullscreenrequest,               class:^itunes.exe$,          title:^iTunes$''
        ''size 472 700,                        class:^itunes.exe$,          title:Info$''
        ''center,                              class:^itunes.exe$,          title:Info$''
        ''pseudo,                              class:^itunes.exe$,          title:MiniPlayer$''
        ''size 600 600,                        class:^itunes.exe$,          title:MiniPlayer$''
        ''forcergbx,                           class:^itunes.exe$,          title:^$''
        ''noanim,                              class:^itunes.exe$,          title:^$''
        ''float,                               class:^firefox$,             title:^Picture-in-Picture$''
        ''size 1920 1080,                      class:^firefox$,             title:^Picture-in-Picture$''
        ''float,                               class:^$,                    title:^Picture in picture$'' # brave
        ''float,                               class:^engrampa$,            title:^Extract$''
        ''float,                               class:^(io.github.Qalculate.qalculate-qt|org\.(gnome\.Calculator|kde\.kruler))$''
        ''noborder,                            class:^org\.kde\.kruler$''

        ''size 410 448,                        class:^winecfg.exe$,         title:^Wine configuration$''
        ''size 500 500,                        class:^msiexec.exe$''

        ''noanim,                              class:^vrmonitor$,           title:^vrmonitor$''
        ''noblur,                              class:^vrmonitor$,           title:^vrmonitor$''
        ''noborder,                            class:^vrmonitor$,           title:^vrmonitor$''

        ''noborder,                            class:^vesktop$,             title:^vesktop$''
        ''noblur,                              class:^vesktop$,             title:^vesktop$''
        ''noshadow,                            class:^vesktop$,             title:^vesktop$''
        # ''noborder,                          class:^vesktop$,             title:^vesktop$''

        # ''monitor current,                   class:^Unity$,               title:^UnityEditor\.ObjectSelector$''

        # ''monitor current,                   class:Unity,                 floating:1''
        # ''center,                            class:Unity,                 floating:1''

        ''float,                               class:^(org.wezfurlong.wezterm)$''
        ''tile,                                class:^(org.wezfurlong.wezterm)$''

        ''fullscreen,                          class:^(steam_app_1229490|hl2_linux)$''

        ''nofocus,                             class:^steam$,               title:^notificationtoasts''
        ''stayfocused,                         class:^steam$,               title:^$''

        ''stayfocused,                         class:^Keybase$''

        ''stayfocused,                         class:^zoom$,                title:^menu window$''
        ''noblur,                              class:^zoom$''

        ''idleinhibit always,                  class:^vrmonitor$''
        # ''idleinhibit focus,                 class:^(gamescope|steam_app_(858210|253030))$''
        ''idleinhibit focus,                   class:^(steam_app_(438100|1468260)|virt-manager)$''
        # ''idleinhibit fullscreen,            class:^itunesvisualizerhost\.exe$''

        # ''opacity 0.0 override 0.0 override, class:^xwaylandvideobridge$, title:^Wayland to X Recording bridge — Xwayland Video Bridge$
        # ''nofocus,                           class:^xwaylandvideobridge$, title:^Wayland to X Recording bridge — Xwayland Video Bridge$
        # ''noinitialfocus,                    class:^xwaylandvideobridge$, title:^Wayland to X Recording bridge — Xwayland Video Bridge$

        ''float,                               class:^mpv$,                 xwayland:1''
        ''nomaxsize,                           class:^mpv$,                 xwayland:1''
      ];
      # workspace = [ "w[v1], border:false" ];
      xwayland.force_zero_scaling = true;
      experimental = {
        # hdr = true;
        xx_color_management_v4 = true;
        # wide_color_gamut = true;
      };
      render.direct_scanout = 1;
      # plugin = {
      #   hyprtrails.color = "rgba(ffaa00ff)";
      # };
      bindl = [
        ", XF86MonBrightnessUp  , exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"
        "SHIFT, XF86MonBrightnessUp  , exec, brightnessctl s 1%+"
        "SHIFT, XF86MonBrightnessDown, exec, brightnessctl s 1%-"

        ", XF86AudioRaiseVolume, exec, amixer -D pulse sset Master 5%+ unmute"
        ", XF86AudioLowerVolume, exec, amixer -D pulse sset Master 5%- unmute"
        "SHIFT, XF86AudioRaiseVolume, exec, amixer -D pulse sset Master 1%+ unmute"
        "SHIFT, XF86AudioLowerVolume, exec, amixer -D pulse sset Master 1%- unmute"
        ", XF86AudioMute,        exec, amixer -D pulse sset Master toggle"
        ", XF86AudioMicMute,        exec, amixer -D pulse sset Capture toggle"

        ", XF86AudioPlay,  exec, playerctl play-pause -i firefox || xdotool search --class itunes.exe key --clearmodifiers XF86AudioPlay"
        ", XF86AudioPause, exec, playerctl pause      -i firefox || xdotool search --class itunes.exe key --clearmodifiers XF86AudioPause"
        ", XF86AudioNext,  exec, playerctl next       -i firefox || xdotool search --class itunes.exe key --clearmodifiers XF86AudioNext"
        ", XF86AudioPrev,  exec, playerctl previous   -i firefox || xdotool search --class itunes.exe key --clearmodifiers XF86AudioPrev"
        "SUPER CTRL ALT SHIFT, BackSpace, exec, pkill hyprlock && hyprlock --immediate"
      ];
      bindm = [
        # Move/resize windows with mainMod + LMB/RMB and dragging
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      "$mainMod" = "SUPER";
      "$up" = "k";
      "$down" = "j";
      "$left" = "h";
      "$right" = "l";

      "$Locker" = "loginctl lock-session";
      bind = [
        # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
        # "$mainMod, Return, exec, rofi-sensible-terminal"
        "$mainMod, Return, exec, if uwsm check is-active; then uwsm app -- rofi-sensible-terminal; else rofi-sensible-terminal; fi"
        "$mainMod, w,      killactive,"

        # "$mainMod, Space, exec, rofi -show drun || wofi --show drun"
        "$mainMod, Space, exec, rofi -show drun || if uwsm check is-active; then uwsm app -- $(wofi --show drun --define=drun-print_desktop_file=true); else wofi --show drun; fi"
        # "$mainMod, x,     exec, env -u WAYLAND_DISPLAY rofi -show drun || wofi --show drun"
        # "$mainMod, Space, exec, wofi --show drun"

        # ", XF86Calculator, exec, qalculate-qt"
        ", XF86Calculator, exec, uwsm app -- qalculate-qt"

        # "$mainMod, e, exec, emacsclient -c"
        "$mainMod, e, exec, if uwsm check is-active; then uwsm app -- emacsclient -c; else emacsclient -c; fi"

        # "$mainMod CTRL, v, exec, wl-paste -n | wtype -"
        "$mainMod CTRL, v, exec, wl-paste -n | xdotool type --clearmodifiers --delay 50 --file -"

        # Move focus with mainMod + arrow keys
        "$mainMod, $up,    movefocus, u"
        "$mainMod, $down,  movefocus, d"
        "$mainMod, $left,  movefocus, l"
        "$mainMod, $right, movefocus, r"

        "$mainMod SHIFT, $up,    movewindow, u"
        "$mainMod SHIFT, $down,  movewindow, d"
        "$mainMod SHIFT, $left,  movewindow, l"
        "$mainMod SHIFT, $right, movewindow, r"

        "$mainMod, bracketleft,  focusmonitor, l"
        "$mainMod, bracketright, focusmonitor, r"

        "$mainMod SHIFT, bracketleft,  movewindow, mon:l"
        "$mainMod SHIFT, bracketright, movewindow, mon:r"

        "$mainMod CTRL, bracketleft,  movecurrentworkspacetomonitor, l"
        "$mainMod CTRL, bracketright, movecurrentworkspacetomonitor, r"

        "$mainMod, f, fullscreen, 0"
        "$mainMod, s, togglefloating,"

        # Switch workspaces with mainMod + [0-9]
        "$mainMod, 1,     workspace, 1"
        "$mainMod, 2,     workspace, 2"
        "$mainMod, 3,     workspace, 3"
        "$mainMod, 4,     workspace, 4"
        "$mainMod, 5,     workspace, 5"
        "$mainMod, 6,     workspace, 6"
        "$mainMod, 7,     workspace, 7"
        "$mainMod, 8,     workspace, 8"
        "$mainMod, 9,     workspace, 9"
        "$mainMod, 0,     workspace, 10"
        "$mainMod, minus, workspace, 11"
        "$mainMod, equal, workspace, 12"

        # Move active window to a workspace with mainMod + SHIFT + [0-9]
        "$mainMod SHIFT, 1,     movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2,     movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3,     movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4,     movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5,     movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6,     movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7,     movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8,     movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9,     movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0,     movetoworkspacesilent, 10"
        "$mainMod SHIFT, minus, movetoworkspacesilent, 11"
        "$mainMod SHIFT, equal, movetoworkspacesilent, 12"

        # Scroll through existing workspaces with mainMod + scroll
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up,   workspace, e-1"

        "$mainMod, Escape, toggleswallow"

        # "$mainMod, M, exit,"

        # "$mainMod, P, pseudo,"      # dwindle
        # "$mainMod, J, togglesplit," # dwindle

        ",       Print, exec, grimblast --notify copysave active"
        "SHIFT, Print, exec, grimblast --notify copysave area"
        "ALT,   Print, exec, grimblast --notify copysave output"
        "CTRL,  Print, exec, grimblast --notify copysave window"

        "SUPER ALT , q , submap , $submap_system"
      ];
      "$submap_system" =
        "System (l) lock, (e) logout, (s) suspend, (h) hibernate, (r) reboot, (Shift+s) shutdown";
    };
    extraConfig = ''
      submap = $submap_system

      bind =,       l, exec,   $Locker
      bind =,       l, submap, reset
      # bind =,       e, exit,
      bind =,       e, exec,   if uwsm check is-active; then uwsm stop; else hyprctl dispatch exit; fi
      bind =,       s, exec,   systemctl suspend
      bind =,       s, submap, reset
      bind =,       h, exec,   systemctl hibernate
      bind =,       h, submap, reset
      bind =,       r, exec,   reboot
      bind = SHIFT, s, exec,   shutdown now

      bind =, Return, submap, reset
      bind =, Escape, submap, reset

      submap = reset
    '';
    # plugins = [ ];
  };
}
