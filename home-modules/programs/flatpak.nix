{ pkgs, ... }:
{
  # Installed via nix-flatpak
  services.flatpak.packages = [
    "app.fluxer.Fluxer"
    #   "app.zen_browser.zen"

    # Not on Flathub; bundle from GitHub releases. Bump url + sha256 to update.
    rec {
      appId = "dev.stormix.deadlock-mod-manager";
      sha256 = "c4e7692ceb716ae303192a68e9a228fc99d66d5483a9cefeef0d1a599cfad066";
      bundle = "${pkgs.fetchurl {
        url = "https://github.com/deadlock-mod-manager/deadlock-mod-manager/releases/download/v2.1.1/deadlock-mod-manager.flatpak";
        inherit sha256;
      }}";
    }
  ];

}
