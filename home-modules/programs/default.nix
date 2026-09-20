{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./cli/lf
    ./cli/btop.nix
  ];

  home.packages = with pkgs; [
    nemo
  ];
}
