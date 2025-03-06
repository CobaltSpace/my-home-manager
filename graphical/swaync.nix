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
  systemd.user.services.swaync = lib.mkForce {};
  # systemd.user.services.swaync = lib.mkForce null;
  # systemd.user.services = lib.mkAfter (
  #   builtins.removeAttrs config.systemd.user.services [ "swaync" ]
  # );
}
