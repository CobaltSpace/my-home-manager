{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.hypridle = lib.mkForce { };
  services.hypridle = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/hypridle) pkgs.emptyDirectory;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        unlock_cmd = "pidof hyprlock || hyprlock && pkill -USR1 hyprlock";
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on || swaymsg 'output * dpms on'"; # to avoid having to press a key twice to turn on the display.
      };
      listener = [
        {
          timeout = 150; # 2.5min.
          on-timeout = "polychromiatic-cli -o brightness 0"; # turn off keyboard backlight.
          on-resume = "polychromiatic-cli -o brightness 100"; # turn on keyboard backlight.
        }
        {
          timeout = 300; # 5min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }
        {
          timeout = 380; # 5.5min
          on-timeout = "hyprctl dispatch dpms off || swaymsg 'output * dpms off'"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on || swaymsg 'output * dpms on'"; # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 80; # .5min
          on-timeout = "pidof hyprlock && { hyprctl dispatch dpms off || swaymsg 'output * dpms on' }"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on || swaymsg 'output * dpms on'"; # screen on when activity is detected after timeout has fired.
        }
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/hyprlock) pkgs.emptyDirectory;
    settings = {
      background = {
        # monitor =
        path = "/usr/share/hypr/wall2.png"; # only png supported for now
        color = "rgba(0, 71, 171, 1.0)";

        # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
        blur_passes = 0; # 0 disables blurring
        blur_size = 7;
        noise = 1.17e-2;
        contrast = 0.8916;
        brightness = 0.8172;
        vibrancy = 0.1696;
        vibrancy_darkness = 0.0;
      };
      input-field = {
        # monitor =
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = false;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        fade_on_empty = true;
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;
        rounding = -1; # -1 means complete rounding (circle/oval)
        check_color = "rgb(204, 136, 34)";
        fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below

        position = "0, -20";
        halign = "center";
        valign = "center";
      };
    };
  };
}
