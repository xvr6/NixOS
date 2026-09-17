{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ../../modules/core
    ../../modules/graphics/nvidia.nix
    ../../modules/programs/media/discord.nix
  ];

  networking.hostName = "nixtop";

  users = {
    mutableUsers = true;
    users.xvr6 = {
      isNormalUser = true;
      initialPassword = "123";
      extraGroups = [
        "wheel" # sudo access
        "input"
        "networkmanager"
        "video"
        "audio"
        "gamemode"
        "libvirtd"
        "kvm"
        "docker"
        "disk"
        "adbusers"
        "lp"
        "scanner"
        "vboxusers" # Virtual Box
      ];
      shell = lib.getExe pkgs.zsh;
      ignoreShellProgramCheck = true;
    };
  };

  nix.settings.allowed-users = [ "xvr6" ];
  environment.systemPackages = with pkgs; [
    plex-desktop
    git
    claude-code
    materialgram
    #   davinci-resolve
  ];
}
