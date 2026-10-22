{ ... }:
{
  # Installed via nix-flatpak
  services.flatpak.packages = [
    "app.fluxer.Fluxer"
    #   "app.zen_browser.zen"
  ];

}
