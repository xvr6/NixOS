{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./cli/lf
    ./cli/btop
    ./cli/eza
  ];

  home.packages = with pkgs; [
    nemo
  ];
}
