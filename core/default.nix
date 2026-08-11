{ pkgs, ... }:
{
  imports = [
    ./boot.nix
    ./fonts.nix
    ./games.nix
    ./hardware.nix
    ./network.nix
    ./nh.nix
    ./packages.nix
    ./printing.nix
    ./sddm.nix
    ./security.nix
    ./services.nix
    ./ssh.nix
    # ./starship.nix
    # ./syncthing.nix
    ./system.nix
    # ./virtualisation.nix
    ./zsh.nix
  ];

  #overlays
  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (nprev: {
        buildInputs =
          nprev.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })
  ];
}
