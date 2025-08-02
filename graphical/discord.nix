{ pkgs, ... }:
{
  # home.packages = with pkgs; [ wine-discord-ipc-bridge ];
  xdg.dataFile =
    let
      discord-flatpak-rpc-bridge = pkgs.fetchFromGitHub {
        owner = "Arcitec";
        repo = "discord-flatpak-rpc-bridge";
        rev = "v1.0.1";
        hash = "sha256-a/16lJU/n9sFMlhPCf3xEdVWqidhutJLb9M0aCQdnWk=";
      };
    in
    {
      "systemd/user/discord-flatpak-rpc-bridge.service".source =
        "${discord-flatpak-rpc-bridge}/discord-flatpak-rpc-bridge.service";
      "systemd/user/discord-flatpak-rpc-bridge.socket".source =
        "${discord-flatpak-rpc-bridge}/discord-flatpak-rpc-bridge.socket";
    };
}
