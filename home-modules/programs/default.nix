{ inputs, ... }:

{
  imports = [
    ./kitty.nix
    ./cli/lf
    ./cli/btop
    ./cli/eza
    ./nemo.nix
    ./media/discord.nix
    ./media/fluxer.nix
    ./media/pear-desktop.nix
    ./media/handbrake
  ];
}
