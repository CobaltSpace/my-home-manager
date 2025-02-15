{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./alacritty.nix
    ./chromium.nix
    ./ghostty.nix
    ./hypr
    ./i3sway
    ./miscpkgs.nix
    ./nixGL.nix
    ./rofi.nix
    ./swaync.nix
    ./waybar.nix
  ];
  nixpkgs.overlays = lib.mkIf (builtins.pathExists /usr/bin/Xwayland) [
    (final: prev: { xwayland = pkgs.emptyDirectory; })
  ];
  home.sessionVariables = {
    XCURSOR_PATH =
      lib.mkIf (config.targets.genericLinux.enable && builtins.isNull config.home.pointerCursor)
        (
          lib.mkForce "${config.xdg.dataHome}/icons:${config.home.homeDirectory}/icons:/usr/share/icons:/usr/share/pixmaps"
        );

    QT_IM_MODULES = "wayland;fcitx;ibus";
    QT_IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";

    TERMINAL = "ghostty";
    VISUAL = "neovide --no-tabs --no-fork";

    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
  home.packages = with pkgs; [
    quicksand
    (lib.mkIf (!lib.pathExists /usr/share/fonts/OTF/ipaexg.ttf) ipaexfont)
    (runCommand "klee-one" { } ''
      mkdir -p $out/share
      ln -s ${
        fetchFromGitHub {
          owner = "fontworks-fonts";
          repo = "Klee";
          tag = "Version1.000";
          # rev = "v${version}";
          hash = "sha256-zjiV6IeY/IdoqhrCJEze6sWo1+ZiDHlUNOm+PRhesaU=";
        }
      }/fonts $out/share
    '')
  ];
}
