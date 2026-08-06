{ pkgs, lib, ... }:
{

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
    ];

  environment.systemPackages = with pkgs; [
    prismlauncher

    protonup-qt
    cabextract # needed for ^

    love
    wineWow64Packages.full
    winetricks
  ];

  hardware.steam-hardware.enable = true;

  programs = {
    # -- gamemode
    gamemode = {
      enable = true;
    };

    # -- gamescope
    gamescope = {
      enable = true;
      #capSysNice = true;
      package = pkgs.gamescope;
      args = [
        "--rt"
        "--expose-wayland"
        # experimental
        # "--immediate-flips"
      ];
    };

    # -- steam
    steam = {
      enable = true;
      extest.enable = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        pkgs.steamtinkerlaunch
        pkgs.proton-ge-bin
      ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "--expose-wayland"
          # "--immediate-flips" # Tearing and low input lag
          # "--adaptive-sync"  # G-Sync/FreeSync
        ];
      };
    };
  };
}
