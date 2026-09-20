{ pkgs, inputs, ... }:

{
  imports = [
    ./programs
    ./desktop/gtk.nix
    ./desktop/noctalia
    ./desktop/umbriel
  ];

  home.username = "xvr6";
  home.homeDirectory = "/home/xvr6";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [ ];
}
