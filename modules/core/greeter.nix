{ ... }:
{
  services.displayManager.noctalia-greeter = {
    enable = true;
    settings.cursor.theme = "Bibata-Modern-Classic";
    passwordless-sync-users = [ "xvr6" ];
  };
}
