{ pkgs, lib, ... }:
{
  boot = {
    supportedFilesystems = lib.mkDefault [
      "ntfs"
      "exfat"
      "ext4"
      "fat32"
      "btrfs"
    ];
    tmp.cleanOnBoot = lib.mkDefault true;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
  };
}
