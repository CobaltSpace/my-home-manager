{ pkgs, ... }:
{
  nixGL = {
    packages = import <nixgl> { inherit pkgs; };

    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };
}
