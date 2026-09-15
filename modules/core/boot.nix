{ pkgs, lib, ... }:
{
  boot = {
    supportedFilesystems = lib.mkDefault [
      "nfs"
      "nfs4"
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];

    kernelModules = [
      "nfs"
    ];

    #boot loader
    loader = {
      efi.canTouchEfiVariables = true;
      efi.efiSysMountPoint = "/boot";
      timeout = 10000;
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        gfxmodeEfi = "1920x1080"; 
        gfxmodeBios = "1920x1080"; 
      };
    };


    tmp.cleanOnBoot = lib.mkDefault true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;

  };
}
