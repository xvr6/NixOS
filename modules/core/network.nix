{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) hostname;
in
{
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
    iproute2
  ];
  
  networking = {
    hostName = "${hostname}";
    networkmanager = {
        enable = true;
        wifi.powersave = false;
    };
    # wireless.enable = true; # Enables wireless support via wpa_supplicant.
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };

    #DNS
    nameservers = [
        "1.1.1.1"
        "1.0.0.1"
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
  };
}
