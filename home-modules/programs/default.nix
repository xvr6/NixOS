{ inputs, ... }:

{
  imports = [
    ./kitty.nix
    ./cli/lf
    ./cli/btop
    ./cli/eza
    ./nemo.nix
    ./media/fluxer.nix
    ./media/pear-desktop.nix
  ];
}
