{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hardware.nix
    ./framework-kmod.nix
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
    ../../modules/core
    ../../modules/graphics/amd.nix
  ];

  networking.hostName = "nixwork";

  users = {
    mutableUsers = true;
    users.xvr6 = {
      isNormalUser = true;
      initialPassword = "123";
      extraGroups = [
        "wheel" # sudo access
        "input"
        "uinput"
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
  ];
}
