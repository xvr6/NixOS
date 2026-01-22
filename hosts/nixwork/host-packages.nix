{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    ludusavi # For game saves
    github-desktop
    ripgrep
    materialgram
    amdgpu_top
   # pokego # Overlayed
  ];
}
