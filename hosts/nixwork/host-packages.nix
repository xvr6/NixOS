{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi # For game saves
    github-desktop
    ripgrep
    # pokego # Overlayed
  ];
}
