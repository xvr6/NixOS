{ host, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 3";
    };
    flake = "/home/xvr6/NixOS";
  };

  # Standalone home-manager (`nh home switch`) has no backup option, only
  # these env vars. Mirrors home-manager.backupFileExtension in flake.nix.
  environment.variables = {
    HOME_MANAGER_BACKUP_EXT = "backup";
    HOME_MANAGER_BACKUP_OVERWRITE = "1";
  };
}
