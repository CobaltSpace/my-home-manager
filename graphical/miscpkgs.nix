{ config, pkgs, ... }: {
  home.packages = with pkgs;
    [
      (config.lib.nixGL.wrap keybase-gui)
      # (config.lib.nixGL.wrap vulkan-hdr-layer-kwin6)
    ];
}
