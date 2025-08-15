{ pkgs, ... }:
{
  imports = [ (builtins.getFlake "github:different-name/steam-config-nix").homeModules.default ];
  programs.steam = {
    config = {
      enable = true;
      closeSteam = true;
      apps = {
        # "438100" = {
        #   compatTool = "GE-Proton10-10";
        #   launchOptions = "PROTON_ENABLE_WAYLAND=1 gamemoderun mangohud %command%";
        # };
      };
    };
  };
}
