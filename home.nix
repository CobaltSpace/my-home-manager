{ config, lib, ... }: {
  imports = [
    # <catppuccin/modules/home-manager>

    ./shell
    ./graphical

    ./miscpkgs.nix
    ./nix.nix
    ./node.nix
    # ./system.nix

    ./local.nix
  ];
  targets.genericLinux.enable = ! builtins.pathExists /etc/nixos;
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

    sessionVariables = {
      XCURSOR_PATH = lib.mkIf (config.targets.genericLinux.enable && builtins.isNull config.home.pointerCursor)
        (lib.mkForce "${config.xdg.dataHome}/icons:${config.home.homeDirectory}/icons:/usr/share/icons:/usr/share/pixmaps");
      env_sources = ''''${env_sources+$env_sources,}home-manager'';
    };
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
