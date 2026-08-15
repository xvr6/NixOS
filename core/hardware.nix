{ pkgs, ... }:
{
  hardware = {
    # sane = {
    #   enable = true;
    #   extraBackends = [ pkgs.sane-airscan ];
    #   disabledDefaultBackends = [ "escl" ];
    # };

    logitech.wireless.enable = true;
    logitech.wireless.enableGraphical = true;

    enableRedistributableFirmware = true;
    keyboard.qmk.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
  };
}
