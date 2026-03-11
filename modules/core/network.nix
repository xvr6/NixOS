{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iproute2
  ];

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = "1";
  };
  networking = {
    hostName = "${hostname}";
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };

    timeServers = [
      # fox time reigns supreme
      "time.foxontheinter.net"

      "0.nixos.pool.ntp.org"
      "1.nixos.pool.ntp.org"
      "2.nixos.pool.ntp.org"
      "3.nixos.pool.ntp.org"
    ];
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    #DNS
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
    ];

    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # SSH (Secure Shell) - remote access
        80 # HTTP - web traffic
        443 # HTTPS - encrypted web traffic
        59010 # Custom application port
        59011 # Custom application port
        8080 # Alternative HTTP/web server port
      ];
      allowedUDPPorts = [
        59010 # Custom application port
        59011 # Custom application port
      ];
    };
    # not needed, using NM
    dhcpcd.enable = false;
  };

  services.dbus = {
    implementation = "dbus";
    #socketActivated = true;
  };
  systemd.services.NetworkManager-wait-online.enable = false;
}
