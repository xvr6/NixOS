{ pkgs, ... }:
{

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
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
  #}
}
