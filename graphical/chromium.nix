{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.programs = {
    chromium.flags = lib.mkOption { };
    brave.flags = lib.mkOption { };
  };
  config =
    let
      renderFlags =
        flags:
        lib.concatStringsSep "\n" (
          lib.remove "" (
            lib.mapAttrsToList (
              name: value:
              if lib.isBool value then
                if value then "--${name}" else ""
              else
                "--${name}=${if lib.isList value then lib.concatStringsSep "," value else toString value}"
            ) flags
          )
        );
    in
    {
      programs = {
        chromium = {
          # enable = true;
          # package = pkgs.emptyDirectory;
          flags = {
            ozone-platform-hint = "auto";
            enable-features = [
              "VaapiVideoDecoder"
              "VaapiIgnoreDriverChecks"
              "Vulkan"
              "DefaultANGLEVulkan"
              "VulkanFromANGLE"
            ];
            disable-features = [
            ];
            enable-wayland-ime = true;
          };
        };
        brave = {
          # enable = true;
          # package = pkgs.emptyDirectory;
          flags = config.programs.chromium.flags;
        };
      };
      xdg.configFile = {
        "chromium-flags.conf".text = renderFlags config.programs.chromium.flags;
        "brave-flags.conf".text = renderFlags config.programs.brave.flags;
      };
      home.file.".var/app/com.brave.Browser/config/brave-flags.conf".text =
        renderFlags config.programs.brave.flags;
    };
}
