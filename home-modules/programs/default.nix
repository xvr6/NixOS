{ inputs, ... }:

{
  imports = [
    ./kitty.nix
    ./flatpak.nix
    ./cli/lf
    ./cli/btop
    ./cli/eza
    ./cli/git.nix
    ./media/discord.nix
    ./media/nemo.nix
    ./media/obsidian
    ./media/pear-desktop.nix
    ./media/handbrake
  ];
}
