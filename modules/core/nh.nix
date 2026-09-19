{ host, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
    flake = "/home/xvr6/NixOS";
    home = "/home/xvr6/NixOS/hosts/${host}/home.nix";
  };

}
