{ config, lib, ... }:
{
  imports = [
    # <catppuccin/modules/home-manager>

    ./shell
    ./graphical

    ./git.nix
    ./keybase.nix
    ./miscpkgs.nix
    ./nix.nix
    ./programming

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

    sessionVariables = with config.home.sessionVariables; {
      EDITOR = "nvim";
      SUDO_EDITOR = EDITOR;
      PAGER = "bat";
      MANPAGER = "bat -p";

      ABDUCO_SOCKET_DIR="\${XDG_RUNTIME_DIR:-/run/user/$UID}";
      GOPATH = "${config.xdg.dataHome}/go";
      FFMPEG_DATADIR = "${config.xdg.dataHome}/ffmpeg";
      AVCONV_DATADIR = FFMPEG_DATADIR;
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      ICEAUTHORITY = "${config.xdg.cacheHome}/ICEauthority";
      MPLAYER_HOME = "${config.xdg.configHome}/mplayer";
      PARALLEL_HOME = "${config.xdg.configHome}/parallel";
      SCREENRC = "${config.xdg.configHome}/screenrc";
      WINEPREFIX = "${config.xdg.dataHome}/wineprefixes/default";
      DISTCC_DIR = "$(systemd-path user-runtime)/distcc";
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
      PASSWORD_STORE_DIR = "${config.xdg.dataHome}/pass";
      STACK_ROOT = "${config.xdg.dataHome}/stack";
      STACK_XDG = 1;
      GHCUP_USE_XDG_DIRS = 1;
      LESSHISTFILE = "${config.xdg.stateHome}/less/history";
      ERRFILE = "${config.xdg.stateHome}/X11/xsession-errors";
      BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
      BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle/config";
      BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";

      DOTNET_CLI_HOME="${config.xdg.dataHome}/dotnet";

      # PATH="$(systemd-path user-binaries):$PATH";

      env_sources = "\${env_sources+$env_sources,}home-manager";
    };
    sessionPath = with config.home.sessionVariables; [
      "$(systemd-path user-binaries)"
      "${config.xdg.configHome}/emacs/bin"
      "${GOPATH}/bin"
      "${DOTNET_CLI_HOME}/tools"
    ];

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
  # services.home-manager.autoUpgrade = {
  #   enable = true;
  #   frequency = "hourly";
  # };
}
