{ pkgs, ... }:

{
  imports = [
    ./kitty.nix
    ./cli/yazi.nix
  ];

  home.packages = with pkgs; [
    nemo
  ];
}
