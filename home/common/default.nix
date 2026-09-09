{ pkgs, ... }:

{
  home.username = "xvr6";
  home.homeDirectory = "/home/xvr6";
  home.stateVersion = "26.05";

  home.packages = with pkgs; [ ];

  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };

  programs.kitty.enable = true;
  programs.noctalia.enable = true;
}
