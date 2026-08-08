{ self, inputs, ... }:
{
  flake.nixosModules.nixtopHardware =
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
            "xhci_pci"
            "ahci"
            "nvme"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ ];
        };
        kernelModules = [ "kvm-intel" ];
        extraModulePackages = [ ];
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
        device = "/dev/disk/by-uuid/5781cc2d-f267-4cbc-86b2-ba0806de6cd8";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/6A5A-0FE7";
        fsType = "vfat";
        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/0f8fd3b8-e868-4ba7-a41f-960df9886cc2"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

      system.stateVersion = "26.05"; # Do not change!
    };
}
