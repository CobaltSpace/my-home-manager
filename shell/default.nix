{ lib, pkgs, ... }: {
  imports = [
    ./zsh.nix
  ];
  home.shellAliases = {
    # home-manager = "home-manager --impure";

    ffmpeg = "nice -n 19 ffmpeg -hide_banner";
    ffprobe = "ffprobe -hide_banner";
    ffplay = "ffplay -hide_banner";

    video2x = "/usr/bin/video2x -c ~/.config/video2x.yaml";
    av1an = "/usr/bin/nice -n 19 /usr/bin/av1an";

    cwebp = "cwebp -progress";

    # ls
    # ls = if (builtins.pathExists /usr/bin/lsd) then "/usr/bin/lsd" else "${pkgs.lsd}/bin/lsd";
    ls = "eza --icons=auto";
    l = "ls -l";
    ll = "ls -l";
    la = "ls -A";
    lla = "ls -lA";
    lal = "ls -Al";
    lt = "ls --tree";
    llt = "ls -l --tree";
    ltl = "ls --tree -l";
    lat = "ls -A --tree";
    lta = "ls --tree -A";
    llat = "ls -lA --tree";
    llta = "ls -l --tree -A";
    latl = "ls -A --tree -l";
    lalt = "ls -Al --tree";
    ltla = "ls --tree -lA";
    ltal = "ls --tree -Al";

    # Color
    diff = "diff --color=auto";
    ping = "prettyping --nolegend";

    doom = "nice -n 19 doom";
    lofi = "mpv --ytdl-format=ba 'ytdl://jfKfPfyJRdk' --no-resume-playback";
    asianlofi = "mpv --ytdl-format=ba 'ytdl://Na0w3Mz46GA' --no-resume-playback";
    synthwave = "mpv --ytdl-format=ba 'ytdl://4xDzrJKXOOY' --no-resume-playback";
    lofirain = "mpv --ytdl-format=ba 'ytdl://-OekvEFm1lo' --no-resume-playback";


    neovide = "neovide --no-tabs --no-fork";

    mpvmic = "mpv --profile=microphone";

    ":q" = "exit";
    ":wq" = "exit";
    edit = "$EDITOR";
    ":e" = "edit";
    open = "xdg-open";
    page = "$PAGER";

    llvmpipe = "LIBGL_ALWAYS_SOFTWARE=true GALLIUM_DRIVER=llvmpipe";
    zink = "MESA_LOADER_DRIVER_OVERRIDE=zink";
    lavapipe = "VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.x86_64.json";
  };
  programs = {
    zoxide = {
      enable = true;
      package = lib.mkIf (builtins.pathExists /usr/bin/zoxide) (pkgs.runCommandLocal "system-zoxide" { } ''
        mkdir -p $out/bin
        ln -s /usr/bin/zoxide $out/bin/
      '');
    };
    starship = {
      # enable = true;
      enableTransience = true;
      package = lib.mkIf (builtins.pathExists /usr/bin/starship) (pkgs.runCommandLocal "system-starship" { } ''
        mkdir -p $out/bin
        ln -s /usr/bin/starship $out/bin/
      '');
    };
    bat = {
      enable = true;
      package = lib.mkIf (builtins.pathExists /usr/bin/bat) (pkgs.runCommandLocal "system-bat" { meta.mainProgram = "bat"; } ''
        mkdir -p $out/bin
        ln -s /usr/bin/bat $out/bin/
      '');
      # catppuccin.enable = true;
      config.theme = "Catppuccin Mocha";
      themes."Catppuccin Mocha" = {
        src = pkgs.catppuccin.override {
          themeList = [ "bat" ];
          variant = "mocha";
        };
        file = "bat/Catppuccin Mocha.tmTheme";
      };
    };
  };
}
