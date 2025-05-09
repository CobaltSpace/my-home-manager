{
  config,
  lib,
  pkgs,
  ...
}:
{
  wayland.windowManager.sway = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/sway) null;
    # (
    #   pkgs.runCommandLocal "system-sway" { } ''
    #     mkdir -p $out/bin
    #     # ln -s /usr/bin/sway $out/bin/
    #     ln -s /usr/bin/swaymsg $out/bin/
    #   ''
    # );
    extraConfigEarly = lib.strings.concatLines [
      # "include /etc/sway/config.d/*"
      "set $Locker loginctl lock-session"
    ];
    checkConfig = !builtins.pathExists /usr/bin/sway;
    xwayland = lib.mkIf (builtins.pathExists /usr/bin/Xwayland) false;
    extraConfig = "xwayland enable";
    config = {
      keybindings =
        let
          modifier = config.wayland.windowManager.sway.config.modifier;
        in
        {
          "Mod1+Mod4+r" = "reload";

          "${modifier}+Return" = "exec '. ${config.xdg.configHome}/sway/vars.env && rofi-sensible-terminal'";
          "${modifier}+w" = "kill";
          "${modifier}+e" = "exec '. ${config.xdg.configHome}/sway/vars.env && emacsclient -c'";
          XF86Calculator = "exec '. ${config.xdg.configHome}/sway/vars.env && qalculate-qt'";
          XF86Tools = "exec '. ${config.xdg.configHome}/sway/vars.env && lutris lutris:rungame/itunes'";
          "${modifier}+Space" =
            "exec '. ${config.xdg.configHome}/sway/vars.env && rofi -show drun || wofi -show drun'";
          "${modifier}+Ctrl+Space" = "exec pkill rofi";
          "${modifier}+Ctrl+Space+Shift" = "exec pkill -KILL rofi";

          # "--release --locked ${modifier}+Delete" = "exec pkill -USR1 swayidle";

          "Print" = "exec grimshot --notify save active";
          "Print+Shift" = "exec grimshot --notify save area";
          "Print+Mod1" = "exec grimshot --notify save output";
          "Print+Ctrl" = "exec grimshot --notify save window";

          "${modifier}+KP_Begin" = "seat - cursor press button1";
          "${modifier}+KP_End" = "seat - cursor move -1  1";
          "${modifier}+KP_Down" = "seat - cursor move  0  1";
          "${modifier}+KP_Next" = "seat - cursor move  1  1";
          "${modifier}+KP_Left" = "seat - cursor move -1  0";
          "${modifier}+KP_Right" = "seat - cursor move  1  0";
          "${modifier}+KP_Home" = "seat - cursor move -1 -1";
          "${modifier}+KP_Up" = "seat - cursor move  0 -1";
          "${modifier}+KP_Prior" = "seat - cursor move  1 -1";
        };
      bars = [ ];
      startup = [
        { command = ". ${config.xdg.configHome}/sway/vars.env && dex -ae sway"; }
        { command = "swaync"; }
        # { command = "systemctl --user stop xdg-desktop-portal-gtk.service"; }

        # { command = "swayidle -w"; }
        { command = "hypridle"; }

        { command = "\"sh -c 'until waybar; do true; done'\""; }
      ];
      seat.seat0.xcursor_theme = "CG";
      input = {
        "type:keyboard".xkb_numlock = "enable";
        "type:touchpad" = {
          dwt = "enable";
          tap = "enable";
          natural_scroll = "enable";
          middle_emulation = "enable";
        };
        "1386:827:Wacom_Intuos_S_2_Pen".map_from_region = "0.0x0.0 1.0x0.9";
      };
      floating.criteria = [
        {
          app_id = "^(org.kde.kruler|org.gnome.Calculator|org.gnome.clocks|pqiv|yad|Tor Browser|qalculate-gtk|io.github.Qalculate.qalculate-qt|hyprland-share-picker)$";
        }
        { class = "^(steam_app_438100)$"; }
        {
          class = "^itunes.exe$";
          title = "^((\w+ )+Info|MiniPlayer)$";
        }
        {
          class = "^Steam$";
          title = "( - event started|^Steam - Self Updater)$";
        }
        {
          class = "^steam_app_1840$";
          title = "Movie Layoff Progress";
        }
        {
          class = "^mpv$";
          instance = "^mpv-vr$";
        }
        {
          app_id = "^zoom$";
          title = "^(zoom|Rename|Breakout Rooms)$";
        }
        {
          class = "^zoom$";
          title = "^(zoom|Rename|Breakout Rooms)$";
        }
        {
          app_id = "^anki$";
          title = "^Add$";
        }
      ];
      window.commands = [
        {
          criteria = {
            class = "^itunes.exe$";
            floating = true;
          };
          command = "move position cursor";
        }
      ];
    };
    # extraConfig = "include config.bak";
  };
}
