{ pkgs, ... }:
{
  imports = [
    ./js.nix
    ./latex.nix
    ./python.nix
    ./rust.nix
  ];
  home.packages = with pkgs; [ exercism ];
}
