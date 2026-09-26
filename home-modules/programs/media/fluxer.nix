{ ... }: {
  # Installed via flatpak (nix-flatpak) to track upstream releases directly
  services.flatpak.packages = [
    "app.fluxer.Fluxer"
  ];
}
