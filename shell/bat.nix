{
  config,
  lib,
  pkgs,
  ...
}:
{
  home = lib.mkIf (config.programs.bat.enable || (builtins.pathExists /usr/bin/bat)) {
    sessionVariables = {
      PAGER = "bat";
      BATDIFF_USE_DELTA = lib.mkIf (
        config.programs.git.delta.enable || (builtins.pathExists /usr/bin/delta)
      ) "true";
    };
    sessionVariablesExtra = lib.mkIf (
      (
        config.programs.bat.enable && builtins.elem pkgs.bat-extras.batman config.programs.bat.extraPackages
      )
      || (builtins.pathExists /usr/bin/batman)
    ) "eval $(batman --export-env)";
  };

  programs.bat = {
    # enable = true;
    # package = lib.mkIf (builtins.pathExists /usr/bin/bat) (
    #   pkgs.runCommandLocal "system-bat" { meta.mainProgram = "bat"; } ''
    #     mkdir -p $out/bin
    #     ln -s /usr/bin/bat $out/bin/
    #   ''
    # );
    # config.theme = "Catppuccin Mocha";
    # themes."Catppuccin Mocha" = {
    #   src = pkgs.catppuccin.override {
    #     themeList = [ "bat" ];
    #     variant = "mocha";
    #   };
    #   file = "bat/Catppuccin Mocha.tmTheme";
    # };
  };
}
