{ osConfig ? { }, ... }:
{
  # Installed via nix-flatpak 
  services.flatpak.packages = [
    "app.fluxer.Fluxer"
  ];

  # /etc/localtime points into /nix/store, which the flatpak sandbox can't
  # resolve, so apps fall back to UTC. Pass the timezone explicitly instead.
  services.flatpak.overrides.global.Environment.TZ =
    osConfig.time.timeZone or "America/New_York";
}
