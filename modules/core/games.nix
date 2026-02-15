{ pkgs, lib, ... }:
{

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
    ];

  environment.systemPackages = with pkgs; [
    bottles
    prismlauncher

    love
    steam-run
    wineWow64Packages.staging
    gamescope
  ];

  hardware.steam-hardware.enable = true;

  programs = {
    # -- gamemode
    gamemode = {
      enable = true;
      settings = {
        #       # Disable ioprio optimisation: on some setups GameMode can't reliably
        #       # apply or verify ioprio, causing noisy "ioprio was (0) but we expected" logs.
        #       general.ioprio = 4;

        #       # Steam registers GameMode from its launch wrapper first, then execs the
        #       # real game; blacklisting the wrapper prevents duplicate-client warnings.
        filter.blacklist = [ "steam-launch-wrapper" ];
      };
    };

    # -- gamescope
    gamescope = {
      enable = true;
      capSysNice = true;
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

      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
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
