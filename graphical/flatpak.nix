{ lib, pkgs, ... }:
{
  imports = [ (builtins.getFlake "github:gmodena/nix-flatpak").homeManagerModules.nix-flatpak ];
  nixpkgs.overlays = lib.mkIf (builtins.pathExists /usr/bin/flatpak) [
    (final: prev: {
      flatpak = pkgs.runCommandLocal "system-flatpak" { } ''
        mkdir -p $out/bin
        ln -s /usr/bin/flatpak $out/bin/
      '';
    })
  ];
  services.flatpak = {
    enable = true;
    update.auto.enable = true;
    packages = [
      "com.github.tchx84.Flatseal"
      "com.obsproject.Studio"
      "com.steamgriddb.SGDBoop"
      "io.ente.auth"
      "io.github.Soundux"
      "net.davidotek.pupgui2"
      "org.freedesktop.Platform.VulkanLayer.MangoHud//24.08"
      "org.vinegarhq.Sober"
      "sh.ppy.osu"
    ]
    ++ builtins.map (obs-plugin: "com.obsproject.Studio.Plugin." + obs-plugin) [
      "DistroAV"
      "OBSVkCapture"
      "SourceRecord"
    ];
    uninstallUnmanaged = true;
    overrides = {
      global.Context.filesystems = [
        "xdg-data/icons:ro"
        "host/nix:ro"
        "xdg-config/MangoHud:ro"
      ];
      "dev.ftb.ftb-app".Context.sockets = "wayland";
    };
  };
}
