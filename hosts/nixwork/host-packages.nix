{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    github-desktop
    ripgrep
    materialgram
    amdgpu_top

    p7zip

    linuxPackages.cpupower
    cpufrequtils
    util-linux

    gcc

    # pokego # Overlayed
  ];
}
