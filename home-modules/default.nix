{ pkgs, inputs, ... }:

{
  imports = [
    ./programs
    ./desktop/noctalia
    ./desktop/umbriel.nix
  ];

  home.username = "xvr6";
  home.homeDirectory = "/home/xvr6";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [ ];

  programs.kitty.enable = true;
}
