{ inputs, ... }:

{
  imports = [
    ./kitty.nix
    ./flatpak.nix
    ./electron-cache.nix
    ./cli/lf
    ./cli/btop
    ./cli/eza
    ./cli/git.nix
    ./media/vesktop.nix
    ./media/nemo.nix
    ./media/obsidian
    ./media/pear-desktop.nix
    ./media/handbrake
  ];
}
