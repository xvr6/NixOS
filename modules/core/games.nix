{ pkgs, lib, ... }:
{

  services.lact.enable = true;

  # Swing/AWT apps (e.g. the packwiz installer bootstrap in Prism) render blank
  # white windows under non-reparenting WMs like umbriel + xwayland-satellite.
  environment.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

  environment.systemPackages = with pkgs; [
    prismlauncher
    packwiz

    parsec-bin

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
          "--adaptive-sync" # G-Sync/FreeSync
        ];
      };
    };
  };
}
