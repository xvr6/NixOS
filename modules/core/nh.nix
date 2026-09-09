{ pkgs, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
    flake = "/home/xvr6/NixOS";
  };

  # environment.systemPackages = with pkgs; [
  #   nix-output-monitor
  #   nvd
  # ];
}
