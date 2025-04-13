{ lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;
    package = lib.mkIf (lib.pathExists /usr/bin/rofi) pkgs.emptyDirectory;
    theme = "DarkBlue";
    font = "Quicksand 12";
    extraConfig = {
      modi = "run,drun,ssh";
      show-icons = true;
      # ssh-command= ''{terminal} -e /bin/sh -i -c "{ssh-client} {host}"'';
      ssh-command = ''/bin/sh -c "if uwsm check is-active; then uwsm app -- {terminal} -e /bin/sh -i -c '{ssh-client} {host}'; else {terminal} -e /bin/sh -i -c '{ssh-client} {host}'; fi"'';
      # run-command= "/bin/sh -c '{cmd}'";
      run-command = ''/bin/sh -c "if uwsm check is-active; then uwsm app -- {cmd}; else {cmd}; fi"'';
      # run-list-command= ". ~/.scripts/zsh_aliases_functions.sh";
      # run-shell-command= ''{terminal} -e /usr/bin/zsh -i -c "{cmd}; read -n 1 -s"'';
      run-shell-command = ''/bin/sh -c "if uwsm check is-active; then uwsm app -- {terminal} -e /usr/bin/zsh -i -c '{cmd}; read -n 1 -s'; else {terminal} -e /usr/bin/zsh -i -c '{cmd}; read -n 1 -s'; fi"'';
      sidebar-mode = true;
    };
  };
}
