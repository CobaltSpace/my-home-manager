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
  xdg.configFile."dunst/dunstrc.d/mocha.conf".source = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/dunst/5955cf0213d14a3494ec63580a81818b6f7caa66/themes/mocha.conf";
    hash = "sha256-v/Ger5s0WUXNUreIM3HvaBcJCR9B4lCrQQrFkW7PSIg=";
  };

  xdg.configFile."systemd/user/dunst.service".enable = false;
  systemd.user.services.dunst.Service = { };
}
