{
  config,
  pkgs,
  ...
}:
{
  home.sessionVariables = {
    # TEXMFCNF="${config.xdg.dataHome}/texmf:";
    TEXMFHOME = "${config.xdg.dataHome}/texmf";
    TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
    TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";
  };
  xdg.configFile = {
    "latexindent/indentconfig.yaml".source = (pkgs.formats.yaml { }).generate "indentconfig.yaml" {
      paths = [ "${config.xdg.configHome}/latexindent/config.yaml" ];
    };
    "latexindent/config.yaml".source = (pkgs.formats.yaml { }).generate "latexindentconfig.yaml" {
      defaultIndent = "  ";
      specialBeginEnd.inlineMathLaTeX = {
        begin = ''(?<!\\)\\\('';
        end = ''\\\)'';
        lookForThis = 1;
      };
    };
    "cluttex/config.toml".source = (pkgs.formats.toml { }).generate "cluttex.toml" {
      temporary-directory = "$XDG_RUNTIME_DIR/cluttex";
    };
  };
  systemd.user.tmpfiles.rules = [ "d %t/latex-build-temp" ];
  home.file.".latex-build-temp".source =
    config.lib.file.mkOutOfStoreSymlink "${builtins.getEnv "XDG_RUNTIME_DIR"}/latex-build-temp";
}
