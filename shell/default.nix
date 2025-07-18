{ lib, pkgs, ... }:
{
  imports = [
    ./zsh.nix
    ./bat.nix
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
      package = lib.mkIf (builtins.pathExists /usr/bin/zoxide) (
        pkgs.runCommandLocal "system-zoxide" { meta.mainProgram = "zoxide"; } ''
          mkdir -p $out/bin
          ln -s /usr/bin/zoxide $out/bin/
        ''
      );
    };
    starship = {
      # enable = true;
      enableTransience = true;
      package = lib.mkIf (builtins.pathExists /usr/bin/starship) (
        pkgs.runCommandLocal "system-starship" { } ''
          mkdir -p $out/bin
          ln -s /usr/bin/starship $out/bin/
        ''
      );
    };
  };
}
