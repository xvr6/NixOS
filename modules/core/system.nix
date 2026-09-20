{ pkgs, ... }:
{
  programs.dconf.enable = true; # gsettings backend; Noctalia's GTK template writes theme/color-scheme here
  services.xserver = {
    enable = true;
    excludePackages = with pkgs; [ xterm ];
    exportConfiguration = true;
    xkb = {
      layout = "us";
    };
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  environment.variables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_BIN_HOME = "$HOME/.local/bin";
  };

  console.keyMap = "us";
  system.stateVersion = "26.05"; # Do not change!
}
