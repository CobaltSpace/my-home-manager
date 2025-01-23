{ lib, pkgs, ... }:
{
  imports = [
    ./alacritty.nix
    ./hypr
    ./i3sway
    ./miscpkgs.nix
    ./nixGL.nix
    ./waybar.nix
  ];
  nixpkgs.overlays = lib.mkIf (builtins.pathExists /usr/bin/Xwayland) [
    (final: prev: { xwayland = pkgs.emptyDirectory; })
  ];
}
