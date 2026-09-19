{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./cli/yazi.nix
    ./cli/btop.nix
  ];

  home.packages = with pkgs; [
    nemo
  ];
}
