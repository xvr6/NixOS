{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iproute2
    iw
    nfs-utils
  ];

  # Network Drives
  fileSystems."/mnt/NAS/mc" = {
    device = "10.0.0.240:/mnt/shitNAS/mc";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "nfsvers=4.0"
    ];
  };

  fileSystems."/mnt/NAS/media" = {
    device = "10.0.0.240:/mnt/shitNAS/media";
    fsType = "nfs";
    options = [
      "noauto"
      "x-systemd.automount"
      "x-systemd.idle-timeout=600"
      "nfsvers=4.0"
    ];
  };

  # Turns on the Linux kernel's ability to act as a router.
  # boot.kernel.sysctl = {
  #   "net.ipv4.ip_forward" = "1";
  # };
  networking = {
    useDHCP = false;
    nftables.enable = true;
    networkmanager = {
      enable = true;
      logLevel = "INFO";
      wifi = {
        backend = "wpa_supplicant";
        powersave = false;
        macAddress = "stable-ssid";
      };
    };

    timeServers = [
      # fox time reigns supreme
      "time.foxontheinter.net"

      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];

    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      allowedTCPPorts = [
        22 # SSH (Secure Shell) - remote access
        80 # HTTP - web traffic
        443 # HTTPS - encrypted web traffic
        8080 # Alternative HTTP/web server port
      ];
      allowedUDPPorts = [
        41641 # Tailscale direct peer connections
        59010 # Custom application port
        59011 # Custom application port
      ];
    };
    # not needed, using NM
    dhcpcd.enable = false;
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "allow-downgrade";
      DNSOverTLS = "opportunistic";
      FallbackDNS = [
        "1.1.1.1#one.one.one.one"
        "8.8.8.8#dns.google"
        "1.0.0.1#one.one.one.one"
      ];
    };
  };

  services.dbus = {
    implementation = "dbus";
    #socketActivated = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
