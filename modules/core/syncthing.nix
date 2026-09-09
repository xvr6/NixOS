{ ... }:
{
  services.syncthing = {
    enable = true;
    user = "xvr6";
    dataDir = "/home/xvr6";
    configDir = "/home/xvr6/.config/syncthing";
  };
}
