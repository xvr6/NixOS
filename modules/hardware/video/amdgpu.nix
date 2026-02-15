{ pkgs, ... }:
{
  imports = [
    ./common.nix
  ];

  boot.initrd.kernelModules = [ "amdgpu" ];
  environment.systemPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.amdsmi
    monado-vulkan-layers
  ];
  services.xserver = {
#   enable = true;
    videoDrivers = [ "amdgpu" ];
  };
  hardware.amdgpu = {
    opencl.enable = true;
    initrd.enable = true;

  };
}
