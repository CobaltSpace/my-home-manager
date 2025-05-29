{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/git) pkgs.emptyDirectory;
    userName = "Cobalt Space";
    userEmail = "cobaltspace@protonmail.com";
    signing = {
      format = null;
      signByDefault = true;
      key = "4D33F57CB5EC1A9B";
    };
    extraConfig = {
      push.autoSetupRemote = true;
      credential.helper = "store";
      init.defaultBranch = "master";
    };

    delta = {
      enable = true;
      package = lib.mkIf (builtins.pathExists /usr/bin/delta) (
        pkgs.runCommandLocal "system delta" { } ''
          mkdir -p $out/bin
          ln -s /usr/bin/delta $out/bin/delta
        ''
      );
      options = {
        pager = "less";
      };
    };
  };
}
