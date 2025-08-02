{
  config,
  lib,
  pkgs,
  ...
}:
let
  waybar-minimal = pkgs.fetchFromGitHub {
    owner = "ashish-kus";
    repo = "waybar-minimal";
    rev = "800e62cc790794bbacf50357492910ba165bdfe4";
    sparseCheckout = [ "src" ];
    hash = "sha256-JQdo/34X9a+SVf0araqlVEuBxyj63EUPM//oodHK+vc=";
  };
  mechabar = pkgs.fetchFromGitHub {
    owner = "sejjy";
    repo = "mechabar";
    rev = "d7cca92e8894c41d9076a99a5042bddb42625ca1";
    hash = "sha256-iwlh3CxVBAHJeI7XBtAQsau9GDOHkEq4q38O9pAW86c=";
  };
in
{
  xdg.configFile = {
    # "waybar/scripts".source = "${waybar-minimal}/src/scripts";
    "waybar/scripts".source = "${mechabar}/scripts";
    "waybar/themes" = {
      source = "${mechabar}/themes";
      recursive = true;
    };
    # "waybar/animation.css".source = "${mechabar}/animation.css";
    "waybar/mechabar.css".source = "${mechabar}/style.css";
    "rofi/themes".source = "${mechabar}/rofi/themes";
    "rofi/bluetooth-menu.rasi".source = "${mechabar}/rofi/bluetooth-menu.rasi";
    "rofi/power-menu.rasi".source = "${mechabar}/rofi/power-menu.rasi";
    "rofi/wifi-menu.rasi".source = "${mechabar}/rofi/wifi-menu.rasi";
  };
  programs.waybar = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/waybar) pkgs.emptyDirectory;
    settings.mainBar =
      let
        wlr_window = {
          format = " {}";
          rewrite =
            let
              brave = "<span font='Font Awesome 6 Brands'> </span>";
            in
            {
              "(.*) - NVIM" = " $1";
              # "(.*) - mpv" = " $1";
              # "(.*) - Twitch — Mozilla Firefox$" = "󰈹  $1";
              # "^(.*) - YouTube — Mozilla Firefox$" = "󰈹  $1";
              # "^(.*) — Mozilla Firefox$" = "󰈹 $1";
              "(.*) — Tor Browser$" = " $1";
              # "(.*) - Twitch - Chromium$" = "  $1";
              # "(.*) - YouTube - Chromium$" = "  $1";
              # "^(.*) - Chromium$" = " $1";
              # "(.*) - Twitch - Brave$" = "${brave} $1";
              # "(.*) - YouTube - Brave$" = "${brave} $1";
              "^(.*) - Brave$" = "${brave}$1";
              "^Zoom Meeting$" = "";
              # "(.*) - Discord" = " $1";
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
        include = [
          # "${waybar-minimal}/src/config"
          # "${mechabar}/themes/jsonc/catppuccin-mocha.jsonc"
          "${config.xdg.configHome}/waybar/config.jsonc"
          # "/etc/xdg/waybar/config.jsonc"
        ];
        # height = 25;
        layer = "top";
        # modules-left = [
        #   "sway/workspaces"
        #   "hyprland/workspaces"
        #   "sway/mode"
        #   "hyprland/submap"
        #   "custom/media"
        #   "sway/window"
        #   "hyprland/window"
        # ];
        modules-center = [
          "custom/paddc"
          "custom/left2"
          "custom/temperature" # temperature

          "custom/left3"
          "memory" # memory

          "custom/left4"
          "cpu" # cpu
          "custom/leftin1"

          "custom/left5"
          "custom/distro" # distro icon
          "custom/right2"

          "custom/rightin1"
          "idle_inhibitor" # idle inhibitor
          "clock#time" # time
          "custom/right3"

          "clock#date" # date
          "custom/right4"

          # "custom/wifi" # wi-fi
          # "bluetooth" # bluetooth
          # "custom/update" # system update
          "pulseaudio" # output device
          "custom/right5"
        ];
        modules-right = [
          "hyprland/submap"
          "mpris" # media info

          "custom/left6"
          "tray"

          "custom/left7"
          "backlight" # brightness

          "custom/left8"
          "battery" # battery

          "custom/leftin2"
          "custom/power" # power button
        ];
        "custom/ws".on-click = "bash ${
          pkgs.runCommandLocal "mechabar-themeswitcher" { } ''
            patch "${mechabar}/scripts/theme-switcher.sh" -o $out << EOF
            --- scripts/theme-switcher.sh	1969-12-31 16:00:01.000000000 -0800
            +++ /tmp/theme-switcher.sh	2025-05-05 03:26:52.229377968 -0700
            @@ -46,9 +46,9 @@
             )
             
             for src in "\''${!theme_files[@]}"; do
            -  cp "\$src" "\''${theme_files[\$src]}"
            +  ln -sf "\$src" "\''${theme_files[\$src]}"
             done
             
             # Restart Waybar to apply changes
             killall waybar || true
            -nohup waybar --config "\$HOME/.config/waybar/config.jsonc" --style "\$HOME/.config/waybar/style.css" >/dev/null 2>&1 &
            +nohup waybar >/dev/null 2>&1 &
            EOF
          ''
        }";
        "sway/workspaces".format = "{name}";
        "wlr/workspaces" = wlr_workspaces;
        "hyprland/workspaces" = lib.attrsets.mergeAttrsList [
          wlr_workspaces
          {
            on-scroll-up = "hyprctl dispatch workspace m+1";
            on-scroll-down = "hyprctl dispatch workspace m-1";
            persistent-workspaces = null;
          }
        ];
        "sway/window" = wlr_window;
        "hyprland/window" = wlr_window;
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
          on-click = "rofi-sensible-terminal -e btop";
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
          # format = [ ];
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
          format = "{icon} {volume}% {format_source}";
          format-muted = "<span color=red>{icon}</span> {volume}% {format_source}";
          format-bluetooth = "{icon}  {volume}% {format_source}";
          format-bluetooth-muted = "<span color=red>{icon} </span> {volume}% {format_source}";
          format-source = " {volume}%";
          format-source-muted = "<span color=red>  </span>{volume}%";
          format-icons = {
            default-muted = "󰝟";
            headphone-muted = "󰟎";
            headset-muted = "󰟎";
          };
          on-click = "pwvucontrol || pavucontrol-qt || pavucontrol";
          on-click-right = "qpwgraph";
          on-click-middle = "easyeffects";
          max-length = null;
        };
        tray.spacing = 5;
      };
    style = # css
      ''
        @import "mechabar.css";
        * {
            /* `otf-font-awesome` is required to be installed for icons */
            /* font-family: "Quicksand", "Symbols Nerd Font", "Font Awesome 6 Free", "Font Awesome 6 Brands", "Klee One SemiBold", "IPAexGothic", Helvetica, Arial, sans-serif; */
        }
        #tray {
          background: @tray;
        }
        #tray menuitem {
          min-height: 1rem;
        }
        #tray menuitem * {
          min-height: inherit;
          margin: .375rem;
        }
        /* #pulseaudio { */
        /*   width: auto; */
        /* } */
      '';
    # ''@import "${waybar-minimal}/src/style.css";'';
  };
}
