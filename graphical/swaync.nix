{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.swaync = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/swaync) (
      pkgs.emptyDirectory.overrideAttrs { meta.mainProgram = ""; }
    );
    settings = {
      positionX = "right";
      positionY = "bottom";
    };
  };
  xdg.configFile."systemd/user/swaync.service".enable = false;
  xdg.configFile."systemd/user/graphical-session.target.wants/swaync.service".enable = false;
  systemd.user.services.swaync.Service = { };
  # systemd.user.services.swaync.Service.ExecStart = lib.mkIf (lib.pathExists /usr/bin/swaync) (
  #   lib.mkForce /usr/bin/swaync
  # );
}
