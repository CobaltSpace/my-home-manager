{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./alacritty.nix
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
}
