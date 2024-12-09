{ lib, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./hypr
    ./i3sway
    ./waybar.nix
  ];
  nixpkgs.overlays = lib.mkIf (builtins.pathExists /usr/bin/Xwayland) [
    (final: prev: { xwayland = pkgs.emptyDirectory; })
  ];
}
