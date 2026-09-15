{ pkgs, inputs, ... }:

{
  imports = [
    ../../modules/programs
    inputs.noctalia.homeModules.default
  ];

  home.username = "xvr6";
  home.homeDirectory = "/home/xvr6";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [ ];

  programs.kitty.enable = true;
}
