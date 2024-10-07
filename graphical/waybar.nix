{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.waybar = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/waybar) pkgs.emptyDirectory;
    settings.mainBar =
      let
        wlr_window = {
          format = " {}";
          rewrite = {
            "(.*) - Twitch — Mozilla Firefox$" = "󰈹  $1";
            "(.*) Subscriptions - YouTube — Mozilla Firefox$" = "󰈹 󰵀 $1";
            "^(.*) - YouTube — Mozilla Firefox$" = "󰈹  $1";
            "^(.*) — Mozilla Firefox$" = "󰈹$1";
            "(.*) — Tor Browser$" = "$1";
            "(.*) - Chromium$" = " $1";
            "^Zoom Meeting$" = " ";
            "(.*) - NVIM" = "$1";
            # "(.*) - zsh" = " [$1]";
          };
        };
        wlr_workspaces = {
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            "5" = "五";
            "6" = "六";
            "7" = "七";
            "8" = "八";
            "9" = "九";
            "10" = "十";
            "11" = "";
            "12" = "";
          };
          sort-by-number = true;
          on-click = "activate";
        };
      in
      {
        include = "/etc/xdg/waybar/config.jsonc";
        height = 25;
        layer = "top";
        modules-left = [
          "sway/workspaces"
          "hyprland/workspaces"
          "sway/mode"
          "hyprland/submap"
          "custom/media"
          "sway/window"
          "hyprland/window"
        ];
        modules-center = [
          "clock"
          "custom/notification"
        ];
        modules-right = [
          "custom/nvchecker"
          # "custom/checkupdates"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "battery"
          "tray"
        ];
        "sway/workspaces".format = "{name}";
        "wlr/workspaces" = wlr_workspaces;
        "hyprland/workspaces" = lib.attrsets.mergeAttrsList [
          wlr_workspaces
          {
            on-scroll-up = "hyprctl dispatch workspace m+1";
            on-scroll-down = "hyprctl dispatch workspace m-1";
          }
        ];
        "sway/window" = wlr_window;
        "hyprland/window" = wlr_window;
        "custom/checkupdates" = {
          exec-on-event = false;
          interval = 60;
          exec = "wc -l /tmp/checkupdates-systemd /tmp/checkupdates-aur-systemd /tmp/aurutils-systemd | tail -n1 | awk '{print $1}'";
          on-click = "notify-send -t 5000 Repos \"$(rg -v 'haskell|kodi|texlive|perl' /tmp/checkupdates-systemd)$([ -n \"$(rg haskell /tmp/checkupdates-systemd)\" ] && echo \"\nhaskell stuff\")$([ -n \"$(rg kodi /tmp/checkupdates-systemd)\" ] && echo \"\nkodi stuff\")$([ -n \"$(rg texlive /tmp/checkupdates-systemd)\" ] && echo \"\ntexlive stuff\")$([ -n \"$(rg perl /tmp/checkupdates-systemd)\" ] && echo \"\nperl stuff\")\" & notify-send -t 5000 AUR \"$(cat /tmp/aurutils-systemd)\"& notify-send -t 5000 PARU \"$(cat /tmp/checkupdates-aur-systemd)\"&";
          on-click-right = "alacritty --hold -e ~/.scripts/updateAUR";
          on-click-middle = "alacritty --hold -e sudo pacmatic -Syu";
          format = " Repo: {}";
        };
        "custom/nvchecker" = {
          exec-on-event = false;
          interval = 60;
          exec = "nvcmp 2> /dev/null | wc -l";
          on-click = "notify-send \"New Version Checker\" \"$(nvcmp)\"";
          format = " Nv: {}";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "command -V swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
        clock = {
          interval = 1;
          format = "{:%T}";
          timezones = [
            "US/Pacific"
            "US/Eastern"
            "Asia/Tokyo"
            "Europe/Amsterdam"
          ];
        };
        cpu.interval = 1;
        memory.interval = 1;
        temperature = {
          interval = 1;
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
          ];
          hwmon-path-abs =
            if (builtins.pathExists "/sys/devices/pci0000:00/0000:00:18.3/hwmon") then
              "/sys/devices/pci0000:00/0000:00:18.3/hwmon"
            else
              lib.mkIf (builtins.pathExists /sys/devices/platform/coretemp.0/hwmon) "/sys/devices/platform/coretemp.0/hwmon";
          input-filename = "temp1_input";
          critical-temperature = 90;
        };
        backlight = {
          scroll-step = 5;
          # format-icons = [ "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ];
          format-icons = [
            "󰛩"
            "󱩎"
            "󱩏"
            "󱩐"
            "󱩑"
            "󱩒"
            "󱩓"
            "󱩔"
            "󱩕"
            "󱩖"
            "󰛨"
          ];
        };
        pulseaudio = {
          on-click-right = "qpwgraph";
          on-click-middle = "easyeffects";
        };
      };
    style = # css
      ''
        @import "/etc/xdg/waybar/style.css" /* layer(default) */;

        * {
            /* `otf-font-awesome` is required to be installed for icons */
            font-family: "Quicksand", "Symbols Nerd Font", "Font Awesome 6 Free", "Font Awesome 6 Brands", "Klee One SemiBold", "IPAexGothic", Helvetica, Arial, sans-serif;
        }

        window#waybar {
            background-color: rgba(0, 0, 0, 0.7);
        }

        #workspaces button.active {
            background-color: #64727D;
            box-shadow: inset 0 -3px #ffffff;
        }
      '';
  };
}
