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
    tmp.cleanOnBoot = lib.mkDefault true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
  };
}
