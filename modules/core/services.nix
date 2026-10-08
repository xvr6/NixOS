{ pkgs, ... }:
{

  # Services to start
  services = {
    power-profiles-daemon.enable = true;
    upower.enable = true;
    rpcbind.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    devmon.enable = true; # For Mounting USB & More
    gvfs.enable = true; # For Mounting USB & More
    udisks2.enable = true; # For Mounting USB & More

    # Manage firmware drivers
    fwupd.enable = true;

    # Flatpak runtime; apps are declared per-user via nix-flatpak's HM module
    flatpak.enable = true;

    # Userspace CPU Scheduler for Improved Latency for Gaming (Hardware Specific)
    # services.scx = {
    #   enable = true;
    #   package = pkgs.scx.rustscheds;
    #   scheduler = "scx_lavd"; # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
    # };

    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
  };
}
