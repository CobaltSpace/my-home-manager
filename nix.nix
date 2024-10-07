{ pkgs, ... }: {
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      # use-xdg-base-directories = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    nurl
    statix
  ];
}
