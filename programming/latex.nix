{ config, pkgs, ... }:
{
  xdg.configFile = {
    "latexindent/indentconfig.yaml".source = (pkgs.formats.yaml { }).generate "indentconfig.yaml" {
      paths = [
        "${config.xdg.configHome}/latexindent/config.yaml"
      ];
    };
    "latexindent/config.yaml".source = (pkgs.formats.yaml { }).generate "latexindentconfig.yaml" {
      defaultIndent = "  ";
    };
  };
}
