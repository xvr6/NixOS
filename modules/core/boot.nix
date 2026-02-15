{ pkgs, ... }:
{
  boot = {
    # Filesystems support
    supportedFilesystems = [
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_zen; # _latest, _zen, _xanmod_latest, _hardened, _rt, _OTHER_CHANNEL, etc.

    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = null; # Display bootloader indefinitely until user selects OS
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "2880x1920"; # for 4k: 3840x2160
        gfxmodeBios = "2880x1920"; # for 4k: 3840x2160
      };
    };
  };
}
