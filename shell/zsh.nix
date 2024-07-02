{ config, lib, pkgs, ... }: {
  programs.zsh = {
    enable = true;
    package = lib.mkIf (builtins.pathExists /usr/bin/zsh) pkgs.emptyDirectory;
    dotDir = lib.strings.removePrefix "${config.home.homeDirectory}/" "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.stateHome}/zshhistory";
      ignoreAllDups = true;
      expireDuplicatesFirst = true;
    };
    defaultKeymap = "viins";
    syntaxHighlighting = {
      enable = true;
      package = lib.mkIf (builtins.pathExists /usr/share/zsh/plugins/zsh-syntax-highlighting) (pkgs.runCommandLocal "system-zsh-syntax-highlighting" { } ''
        mkdir -p $out/share
        ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting $out/share/
      '');
    };
    autosuggestion.enable = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = "$terminfo[kcuu1]";
      searchDownKey = "$terminfo[kcud1]";
    };
    initExtraFirst =
      if (with config.programs.starship; enable && enableZshIntegration) then "prompt off"
      else
        lib.strings.concatLines [
          # Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          # sh
          ''[[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]] && source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"''
          (
            if (builtins.pathExists /usr/share/zsh-theme-powerlevel10k)
            then ''source "/usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme"''
            else ''source "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme"''
          )
          # To customize prompt, run `p10k configure` or edit $config_home/zsh/.p10k.zsh.
          # sh
          ''
            if [ "$TERM" = linux ]; then
              [[ ! -f "${config.xdg.configHome}/zsh/.p10k-tty.zsh" ]] || source "${config.xdg.configHome}/zsh/.p10k-tty.zsh"
            else
              [[ ! -f "${config.xdg.configHome}/zsh/.p10k.zsh" ]] || source "${config.xdg.configHome}/zsh/.p10k.zsh"
            fi
          ''
        ];
    initExtra = lib.strings.concatLines [
      (lib.strings.optionalString (builtins.pathExists /usr/share/zsh) "unset HELPDIR")
      # sh
      ''
        fpath+=(${config.xdg.dataHome}/zsh/site-functions/)
        compinit -d ${config.xdg.cacheHome}/zsh/zcompdump-$ZSH_VERSION
        zstyle ':completion:*' cache-path ${config.xdg.cacheHome}/zsh/zcompcache

        setopt HIST_REDUCE_BLANKS

        source ${config.xdg.configHome}/privaterc

        source "${pkgs.zsh-nix-shell}/share/zsh-nix-shell"

        zstyle ':completion:*' rehash true

        unalias lsd

        eval "$(pnpm completion zsh)"

        export env_sources="''${env_sources+$env_sources,}zsh.nix"
      ''
    ];
  };
}
