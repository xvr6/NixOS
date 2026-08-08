{ pkgs, ... }:
{
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true; # Recommended for modern Turing/Ada Lovelace GPUs or newer
  };
  services.xserver.videoDrivers = [ "nvidia" ];
}
