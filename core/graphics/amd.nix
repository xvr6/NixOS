{ pkgs, ... }:
{
  boot.initrd.kernelModules = [ "amdgpu" ];
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.amdsmi
    #  monado-vulkan-layers
  ];
  services.xserver = {
    #   enable = true;
    videoDrivers = [ "amdgpu" ];
  };

  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;
  };

  #graphics = {
  #  extraPackages = with pkgs; [
  #    amdvlk
  #    libva-mesa-driver
  #    mesa
  #  ];
  #  extraPackages32 = with pkgs.driversi686Linux; [
  #    amdvlk
  #    libva-mesa-driver
  #  ];
  #};
}
