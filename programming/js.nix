{ config, lib, pkgs, ... }:
{
  home = {
    sessionVariables = {
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npmrc";
      NVM_DIR = "${config.xdg.dataHome}/nvm";
    };
    sessionPath = [
      "${config.xdg.dataHome}/npm/bin"
    ];
    packages = with pkgs;[
      biome
    ];
  };
  xdg.configFile.npmrc.text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      prefix = "${config.xdg.dataHome}/npm";
      cache = "${config.xdg.cacheHome}/npm";
      init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
      logs-dir = "${config.xdg.stateHome}/npm/logs";
    };
  };
}
