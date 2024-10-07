{ lib, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./hypr
    ./i3sway
    ./waybar.nix
  ];
}
