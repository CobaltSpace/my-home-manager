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
    ./discord.nix
    ./flatpak.nix
    ./ghostty.nix
    ./hypr
    ./i3sway
    ./miscpkgs.nix
    ./mpv.nix
    ./neovide.nix
    ./nixGL.nix
    ./notifications.nix
    ./rofi.nix
    ./steam.nix
    ./waybar.nix
    ./zathura.nix
  ];
  # nixpkgs.overlays = lib.mkIf (builtins.pathExists /usr/bin/Xwayland) [
  #   (final: prev: { xwayland = pkgs.emptyDirectory; })
  # ];
  home = {
    sessionVariables = {
      # XCURSOR_PATH =
      #   lib.mkIf
      #     (
      #       config.targets.genericLinux.enable
      #       && (builtins.isNull config.home.pointerCursor || !config.home.pointerCursor.enable)
      #     )
      #     (
      #       lib.mkForce "${config.xdg.dataHome}/icons:${config.home.homeDirectory}/icons:/usr/share/icons:/usr/share/pixmaps"
      #     );

      QT_IM_MODULES = "wayland;fcitx;ibus";
      QT_IM_MODULE = "fcitx";
      # GTK_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      SDL_IM_MODULE = "fcitx";

      TERMINAL = "ghostty";
      VISUAL = "neovide --no-tabs --no-fork";

      GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";

      ELECTRON_OZONE_PLATFORM_HINT = "auto";
    };
    sessionSearchVariables.XCURSOR_PATH = [
      "${config.xdg.dataHome}/icons"
      "${config.home.homeDirectory}/icons"
    ];
    # pointerCursor = {
    #   enable = true;
    #   package = pkgs.posy-cursors;
    #   name = "Posy_Cursor";
    #   gtk.enable = true;
    #   hyprcursor.enable = true;
    #   x11.enable = true;
    # };
    packages = with pkgs; [
      posy-cursors
      monocraft
      miracode
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
  };
}
