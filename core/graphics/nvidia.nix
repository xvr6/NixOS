{ config, pkgs, ... }:
# https://wiki.nixos.org/wiki/NVIDIA
{
  imports = [ ./common.nix ];

  boot = {
    initrd.kernelModules = [ "nvidia" ];
    extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  };
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    powerManagement.enable = false;
    open = true;
    nvidiaSettings = true;
  };
  services.xserver.videoDrivers = [
    "modesetting" # igpu
    "nvidia"
  ];
}
