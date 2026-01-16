{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-unwrapped"
    ];
  hardware.graphics = {
   # enabled = true; #already enabled in hardware/gpu/amde/:
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    bottles
    prismlauncher
    mangohud

    wineWowPackages.staging
    # balatro # used to be a thing? look into how declaratively importing steam games work.
    love # Compat for LOVE (engine) based games 
    gamemode
    ];
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
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
  };
}
