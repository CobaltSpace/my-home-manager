{ lib, pkgs, ... }:
{
  services.swaync = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/swaync) pkgs.emptyDirectory;
    settings = {
      positionX = "right";
      positionY = "bottom";
    };
  };
}
