{
  config,
  lib,
  pkgs,
  ...
}:
let
  npmrc = {
    prefix = "${config.xdg.dataHome}/npm";
    cache = "${config.xdg.cacheHome}/npm";
    init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
    logs-dir = "${config.xdg.stateHome}/npm/logs";
  };
in
{
  xdg.configFile."npm/npmrc".text = lib.generators.toINIWithGlobalSection { } {
    globalSection = npmrc;
  };
  home = {
    sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      NVM_DIR = "${config.xdg.dataHome}/nvm";
    };
    sessionPath = [ "${npmrc.prefix}/bin" ];
    packages = with pkgs; lib.mkIf (!builtins.pathExists /usr/bin/biome) [ biome ];
  };
}
