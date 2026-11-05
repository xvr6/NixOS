{ pkgs, ... }:
{
  services.displayManager.noctalia-greeter = {
    enable = true;
    # Keep in sync with home.pointerCursor in home-modules/desktop/gtk.nix
    settings.cursor = {
      theme = "capitaine-cursors";
      size = 24;
      path = pkgs.capitaine-cursors;
    };
    passwordless-sync-users = [ "xvr6" ];
  };
}
