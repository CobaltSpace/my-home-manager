{
  config,
  pkgs,
  ...
}:
{
  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # use-xdg-base-directories = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
  programs.nh.enable = true;
  home.packages = with pkgs; [
    nixd
    nixfmt-rfc-style
    nurl
    statix
  ];
  # home.shellAliases.home-manager = "home-manager --impure";
  # home.shellAliases.home-manager = "home-manager --impure --flake='path:${config.xdg.configHome}/home-manager'";
}
