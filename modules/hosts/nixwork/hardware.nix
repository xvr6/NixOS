{ self, inputs, ... }:
{
  flake.nixosModules.nixworkHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "thunderbolt"
          ];
          kernelModules = [ ];
        };

        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];

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

      fileSystems."/" = {
        device = "/dev/disk/by-uuid/e1e79c49-c772-4c13-9d3e-ccfe7bcd815d";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/7726-4BF9";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/52cd1573-cbd2-4480-8b8e-f690b663042c"; }
      ];

      nixpkgs.hostPlatform = lib.mkForce "x86_64-linux";
      hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      system.stateVersion = "26.05"; # Do not change!
    };
}
