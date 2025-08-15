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
      "dev.ftb.ftb-app"
      "io.ente.auth"
      "org.vinegarhq.Sober"
      "net.davidotek.pupgui2"
      "sh.ppy.osu"
    ]
    ++ builtins.map (obs-plugin: "com.obsproject.Studio.Plugin." + obs-plugin) [
      "OBSVkCapture"
    ];
    uninstallUnmanaged = true;
    overrides = {
      global.Context.filesystems = "xdg-data/icons:ro";
    };
  };
}
