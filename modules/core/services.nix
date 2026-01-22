{ ... }:
{
  # Services to start
  services = {
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    devmon.enable = true; # For Mounting USB & More
    gvfs.enable = true; # For Mounting USB & More
    udisks2.enable = true; # For Mounting USB & More

    # Userspace CPU Scheduler for Improved Latency for Gaming (Hardware Specific)
    # services.scx = {
    #   enable = true;
    #   package = pkgs.scx.rustscheds;
    #   scheduler = "scx_lavd"; # https://github.com/sched-ext/scx/blob/main/scheds/rust/README.md
    # };

    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview

    avahi.enable = true; #Airplay/RAOP - required for service discovery

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      # wireplumber = {
      #   enable = true;
      #   configPackages = [
      #     (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/11-bluetooth-policy.conf" ''
      #       bluetooth.autoswitch-to-headset-profile = false
      #     '')
      #   ];
      # };
    
        #Airplay/RAOP
      raopOpenFirewall = true;
      extraConfig.pipewire = {
        "10-airplay" = {
            "context.modules" = [ {
                name = "libpipewire-module-raop-discover";
                args = {
                    # "raop.latency.ms" = 500; #If lag/dropouts occur, try increasing buffer.
                };
            } ];
        };


        "92-low-latency" = {
            "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 2048;
            };
        };
        "92-low-latency" = {
            context.modules = [
            {
                name = "libpipewire-module-protocol-pulse";
                args = {
                    pulse.min.req = "256/48000";
                    pulse.default.req = "256/48000";
                    pulse.max.req = "256/48000";
                    pulse.min.quantum = "256/48000";
                    pulse.max.quantum = "256/48000";
                };
            }
            ];
        };
      };
    };
  };
}
