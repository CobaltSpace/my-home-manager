{ lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/rofi) pkgs.emptyDirectory;
    theme = "DarkBlue";
    font = "Quicksand 12";
    extraConfig = {
        modi= "run,drun,ssh";
        show-icons= true;
        ssh-command= ''{terminal} -e /bin/sh -i -c "{ssh-client} {host}"'';
        run-command= "/bin/sh -c '{cmd}'";
        /* run-list-command= ". ~/.scripts/zsh_aliases_functions.sh"; */
        run-shell-command= ''{terminal} -e /usr/bin/zsh -i -c "{cmd}; read -n 1 -s"'';
        sidebar-mode= true;
    };
  };
}
