{ config, lib, ... }: {
  xdg.configFile.npmrc.text = lib.generators.toINIWithGlobalSection { } {
    globalSection = {
      prefix = "${config.xdg.dataHome}/npm";
      cache = "${config.xdg.cacheHome}/npm";
      init-module = "${config.xdg.configHome}/npm/config/npm-init.js";
      logs-dir = "${config.xdg.stateHome}/npm/logs";
    };
  };
}
