{ config, pkgs, ... }:
{
  home.packages =
    with pkgs;
    builtins.map (pkg: config.lib.nixGL.wrap pkg) [
      keybase-gui
      vulkan-hdr-layer-kwin6
      alcom
    ];
}
