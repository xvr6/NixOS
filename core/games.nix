{ pkgs, lib, ... }:
{

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
    ];

  services.lact.enable = true;

  environment.systemPackages = with pkgs; [
    prismlauncher

    protonup-qt
    cabextract # needed for ^

    love
    wineWow64Packages.full
    winetricks

    lact

    vulkan-tools # vulkaninfo, vkcube
    mesa-demos # glxinfo, glxgears
  ];

  hardware.steam-hardware.enable = true;

  programs = {
    # -- gamemode
    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
        };

        # Warning: GPU optimisations have the potential to damage hardware
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          nv_powermizer_mode = 1;
          amd_performance_level = "high";
        };
        cpu = {
          park_cores = "no";
          pin_cores = "yes";
        };

        custom = {
          start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
          end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        };
      };
    };

    # -- gamescope
    gamescope = {
      enable = true;
    };

    # -- steam
    steam = {
      enable = true;
      extest.enable = true;
      protontricks.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        steamtinkerlaunch
        proton-ge-bin
      ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--rt"
          "--expose-wayland"
          "--immediate-flips" # Tearing and low input lag
          "--adaptive-sync"  # G-Sync/FreeSync
        ];
      };
    };
  };
}
