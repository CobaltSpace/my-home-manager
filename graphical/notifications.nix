{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.swaync = {
    # enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/swaync) (
      pkgs.emptyDirectory.overrideAttrs { meta.mainProgram = ""; }
    );
    settings = {
      positionX = "right";
      positionY = "bottom";
    };
  };
  xdg.configFile."systemd/user/swaync.service".enable = false;
  systemd.user.services.swaync.Service = { };
  # systemd.user.services.swaync.Service.ExecStart = lib.mkIf (lib.pathExists /usr/bin/swaync) (
  #   lib.mkForce /usr/bin/swaync
  # );

  services.dunst = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/dunst) pkgs.emptyDirectory;
    settings = {
      global = {
        width = 300;
        height = "(0, 8192)";
        # offset = "30x50";
        origin = "bottom-right";
        transparency = 10;
        # frame_color = "#eceff1";
        # font = "Droid Sans 9";
      };

      urgency_normal = {
        # background = "#37474f";
        # foreground = "#eceff1";
        timeout = 10;
      };
    };
  };

  xdg.configFile."systemd/user/dunst.service".enable = false;
  systemd.user.services.dunst.Service = { };
}
