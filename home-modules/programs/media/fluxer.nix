{ osConfig ? { }, ... }:
{
  # Installed via nix-flatpak 
  services.flatpak.packages = [
    "app.fluxer.Fluxer"
  ];

}
