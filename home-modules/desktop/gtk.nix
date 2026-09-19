{ pkgs, ... }:

# Nemo (GTK3) and other GTK apps now pick up Noctalia colors via the gtk3/gtk4 templates
{
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };

    gtk3.extraCss = ''@import url("noctalia.css");'';
    gtk4.extraCss = ''@import url("noctalia.css");'';
  };

  # Lets Noctalia sync gtk-theme / color-scheme on mode changes.
  home.packages = [ pkgs.dconf ];
}
