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
      key = "4D33F57CB5EC1A9B";
    };
    extraConfig = {
      push.autoSetupRemote = true;
      credential.helper = "store";
      init.defaultBranch = "master";
    };
  };
}
