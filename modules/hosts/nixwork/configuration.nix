{ self, inputs, ... }:
{
  flake.nixosModules.nixworkConfig =
    { pkgs, lib, ... }:
    let

      inherit (import ./_variables.nix) gpu;
    in
    {
      imports = [
        self.nixosModules.nixworkHardware
        inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series
        self.nixosModules.core
        ../../../core/graphics/${gpu}.nix
        self.nixosModules.niri
        self.nixosModules.discord
      ];

      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

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
        lufus
        packwiz
        plex-desktop
        parsec-bin
        nh
        git
        claude-code
        materialgram
        pear-desktop
      ];
    };

}
