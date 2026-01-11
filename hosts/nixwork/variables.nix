{
  username = "xvr6"; # auto-set with install.sh, live-install.sh, and rebuild scripts.

  # Desktop Environment
  desktop = "hyprland"; # hyprland, i3, gnome, plasma6

  # Theme & Appearance
  waybarTheme = "minimal"; # stylish, minimal
  sddmTheme = "black_hole"; # astronaut, black_hole, purple_leaves, jake_the_dog, hyprland_kath
  defaultWallpaper = "train-sideview.webp"; # Change with SUPER + SHIFT + W
  hyprlockWallpaper = "train-sideview.webp";

  # Default Applications
  terminal = "kitty"; # kitty, alacritty
  editor = "nixvim"; # nixvim, vscode, helix, doom-emacs, nvchad, neovim
  browser = "zen"; # zen, firefox, floorp
  tuiFileManager = "yazi"; # yazi, lf
  shell = "zsh"; # zsh, bash
  games = false; # Enable/Disable gaming module

  # Hardware
  hostname = "nixwork";
  videoDriver = "amdgpu"; # nvidia, amdgpu, intel

  # Localization
  timezone = "America/New_York";
  locale = "en_US.UTF-8";
  clock24h = true;
  kbdLayout = "us";
  kbdVariant = "extd";
  consoleKeymap = "us";
}
