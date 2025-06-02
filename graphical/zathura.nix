{ pkgs, ... }:
{
  programs.zathura = {
    enable = true;
    package = pkgs.emptyDirectory;
    options = {
      synctex = true;
      synctex-editor-command = "texlab inverse-search -i %{input} -l %{line}";
    };
  };
}
