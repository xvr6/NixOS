{ pkgs, ... }:

{
    imports = [
        ./common.nix
    ];

    boot.initrd.kernelModules = ["amdgpu"];
    
    services.xserver = {
        # enable = true;  # Already enabled in display manager
        videoDrivers = [ "amdgpu" ];
    };

}
