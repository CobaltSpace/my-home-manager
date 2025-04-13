{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.swaync = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/swaync) pkgs.emptyDirectory;
    settings = {
      positionX = "right";
      positionY = "bottom";
    };
  };
  xdg.configFile."systemd/user/swaync.service".enable = false;
  systemd.user.services.swaync.Service.ExecStart = lib.mkForce /usr/bin/swaync;
}
