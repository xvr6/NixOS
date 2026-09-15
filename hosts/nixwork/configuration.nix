{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    inputs.umbriel.nixosModules.default
    ../../modules/core
    ../../modules/graphics/amd.nix
    ../../modules/programs/media/discord.nix
  ];

  networking.hostName = "nixwork";

  programs.umbriel.enable = true;
  # Registers the Umbriel session with the display manager (greeters only pick up
  # sessions via services.displayManager.sessionPackages, not home-manager's
  # user-profile .desktop file).

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
    packwiz
    plex-desktop
    parsec-bin
    nh
    git
    claude-code
    materialgram
    pear-desktop
  ];
}
