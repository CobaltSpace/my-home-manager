{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.emptyDirectory;
    userName = "Cobalt Space";
    userEmail = "cobaltspace@protonmail.com";
    signing = {
      format = null;
      signByDefault = true;
    };
    extraConfig = {
      push.autoSetupRemote = true;
      credential.helper = "store";
      init.defaultBranch = "master";
    };
  };
}
