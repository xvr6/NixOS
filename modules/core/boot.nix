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
      timeout = 10;
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
    # FIXME:
    # 7.3.4 NULL-derefs in a BH workqueue during xhci_hcd init (initrd panic); revert to zen once fixed.
    kernelPackages = pkgs.linuxPackages_6_18;
  };
}
