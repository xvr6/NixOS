{ inputs, pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./games.nix
    ./greeter.nix
    ./hardware.nix
    ./network.nix
    ./nh.nix
    ./nix.nix
    ./packages.nix
    ./printing.nix
    ./security.nix
    ./services.nix
    ./ssh.nix
    # ./starship.nix
    # ./syncthing.nix
    ./system.nix
    # ./virtualisation.nix
    ./zsh.nix
  ];

  nixpkgs.overlays = [
    inputs.fluxer.overlays.default
  ];
}
