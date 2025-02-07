{ config, lib, ... }:
{
  imports = [
    # <catppuccin/modules/home-manager>

    ./shell
    ./graphical

    ./keybase.nix
    ./miscpkgs.nix
    ./nix.nix
    ./node.nix
    # ./system.nix

    ./local.nix
  ];
  targets.genericLinux.enable = !builtins.pathExists /etc/nixos;
  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = builtins.getEnv "USER";
    homeDirectory = builtins.getEnv "HOME";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.

    sessionVariables = with config.home.sessionVariables;{
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
      EDITOR = "nvim";
      SUDO_EDITOR = EDITOR;
      VISUAL = "neovide --no-tabs --no-fork";
      PAGER = "bat";
      MANPAGER = "bat -p";

      GOPATH = "${config.xdg.dataHome}/go";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
      FFMPEG_DATADIR = "${config.xdg.dataHome}/ffmpeg";
      AVCONV_DATADIR = FFMPEG_DATADIR;
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      ICEAUTHORITY = "${config.xdg.cacheHome}/ICEauthority";
      MPLAYER_HOME = "${config.xdg.configHome}/mplayer";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npmrc";
      PARALLEL_HOME = "${config.xdg.configHome}/parallel";
      SCREENRC = "${config.xdg.configHome}/screenrc";
      WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
      DISTCC_DIR = "/tmp/distcc";
      # TEXMFCNF="${config.xdg.dataHome}/texmf:";
      TEXMFHOME = "${config.xdg.dataHome}/texmf";
      TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
      TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";
      ASPELL_CONF = "per-conf ${config.xdg.configHome}/aspell/aspell.conf; personal ${config.xdg.configHome}/aspell/en.pws; repl ${config.xdg.configHome}/aspell/en.prepl";
      GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
      KODI_DATA = "${config.xdg.dataHome}/kodi";
      ANDROID_HOME = "${config.xdg.dataHome}/android";
      CALCHISTFILE = "${config.xdg.cacheHome}/calc_history";
      NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages                                                             ";
      NVM_DIR = "${config.xdg.dataHome}/nvm";
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
      PYTHONSTARTUP = "${config.xdg.configHome}/pythonrc";
      STACK_ROOT = "${config.xdg.dataHome}/stack";
      STACK_XDG = 1;
      GHCUP_USE_XDG_DIRS = 1;
      GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc:${config.xdg.configHome}/gtk-2.0/gtkrc.mine";
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      ERRFILE = "${config.xdg.stateHome}/X11/xsession-errors";
      BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
      BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
      BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";

      PATH="$(systemd-path user-binaries):${config.xdg.configHome}/emacs/bin:${CARGO_HOME}/bin:${GOPATH}/bin:${config.xdg.dataHome}/npm/bin:~/.dotnet/tools:$PATH";

      env_sources = "\${env_sources+$env_sources,}home-manager";
    };

    preferXdgDirectories = true;
  };

  xdg.userDirs = {
    enable = true;
    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  services.home-manager.autoUpgrade = {
    enable = true;
    frequency = "hourly";
  };
}
