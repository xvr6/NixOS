{
  self,
  inputs,
  pkgs,
  lib,
  ...
}:
{
  # TODO: review
  programs = {

    #   btop = {
    #     enable = true;
    #     package = pkgs.btop.override {
    #       rocmSupport = true;
    #       cudaSupport = true;
    #     };
    #     settings = {
    #       color_theme = "catppuccin-mocha";
    #       show_gpu_info = "on";
    #       cpu_sensor = "auto";
    #       vim_keys = true;
    #       rounded_corners = true;
    #       proc_tree = false;
    #       show_uptime = true;
    #       show_coretemp = true;
    #       show_disks = true;
    #       only_physical = true;
    #       io_mode = true;
    #       io_graph_combined = false;
    #     };
    #   };

    #   thunar = {
    #     enable = true;
    #     plugins = with pkgs; [
    #       thunar-archive-plugin # Archive management
    #       thunar-volman # Volume management (automount removable devices)
    #       thunar-media-tags-plugin # Tagging & renaming feature for media files
    #     ];
    #   };
    fuse.userAllowOther = true;
    mtr.enable = true;
    #adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.12"
  ];

  # Default XDG mime handlers: imv for images, kitty+nvim for text/code
  # (declarative equivalent of home-manager's xdg.mimeApps, since this
  # config doesn't use home-manager).
  environment.etc."xdg/mimeapps.list".text =
    let
      imageMimeTypes = [
        "image/x-farbfeld"
        "image/tiff"
        "image/tiff-fx"
        "image/png"
        "image/x-png"
        "image/jpeg"
        "image/jpg"
        "image/pjpeg"
        "image/svg+xml"
        "image/gif"
        "image/bmp"
        "image/x-bmp"
        "image/heif"
        "image/avif"
        "image/jxl"
        "image/webp"
        "image/qoi"
      ];
      textMimeTypes = [
        "text/plain"
        "text/markdown"
        "text/x-shellscript"
        "text/x-python"
        "text/x-csrc"
        "text/x-chdr"
        "text/x-nix"
        "text/x-log"
        "text/csv"
        "text/html"
        "text/css"
        "text/x-diff"
        "application/json"
        "application/x-yaml"
        "application/xml"
        "application/javascript"
      ];
      defaultsFor =
        desktopFile: mimeTypes: lib.concatMapStringsSep "\n" (m: "${m}=${desktopFile}") mimeTypes;
    in
    ''
      [Default Applications]
      ${defaultsFor "imv.desktop" imageMimeTypes}
      ${defaultsFor "kitty-nvim.desktop" textMimeTypes}
    '';

  environment.systemPackages = with pkgs; [
    gvfs
    nemo
    imv
    self.packages.${pkgs.stdenv.hostPlatform.system}.myKittyNvim
    lshw
    file-roller # needed for thunar
    ventoy
    gnumake
    appimage-run # Needed For AppImage Support
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    rclone # Cloning Utility
    jq # Json Formatting Utility
    bibata-cursors
    sddm-astronaut # Sddm Theme (Overlayed)
    kdePackages.qtsvg # Sddm Dependency
    kdePackages.qtmultimedia # Sddm Dependency
    kdePackages.qtvirtualkeyboard # Sddm Dependency
    fzf # Fuzzy Finder
    fd # Better Find
    git # Git
    gh # Github Authentication Client
    libjxl # Support for JXL Images
    microfetch # Small fetch (Blazingly fast)
    ripgrep # Improved Grep
    tldr # Improved Man
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    # aider-chat # AI in terminal (Optional: Client only)
    curl
    cmatrix # Matrix Movie Effect In Terminal
    cowsay # Great goFun Terminal Program
    # duf # Utility For Viewing Disk Usage In Terminal
    dysk # Disk space util nice formattting
    ffmpeg # Terminal Video / Audio Editing
    # glxinfo # needed for inxi diag util
    # inxi # CLI System Information Tool
    libsForQt5.qt5.qtgraphicaleffects # Sddm Dependency (Old)
    libnotify # For Notifications
    lolcat # Add Colors To Your Terminal Command Output
    # lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    # ncdu # Disk Usage Analyzer With Ncurses Interface
    # nixfmt-rfc-style # Nix Formatter
    # nwg-displays # configure monitor configs via GUI
    # onefetch # provides zsaneyos build info on current system
    # pavucontrol # For Editing Audio Levels & Devices
    # pciutils # Collection Of Tools For Inspecting PCI Devices
    picard # For Changing Music Metadata & Getting Cover Art
    # pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    # rhythmbox # audio player
    # socat # Needed For Screenshots
    # usbutils # Good Tools For USB Devices
    # uwsm # Universal Wayland Session Manager (optional must be enabled)
    v4l-utils # Used For Things Like OBS Virtual Camera
    # waypaper # Change wallpaper
    wget # Tool For Fetching Files With Links
    ytmdl # Tool For Downloading Audio From YouTube

    gcc

    btop-cuda
    # devenv
    # devbox
    # shellify

    #NOTE: these imports are here until i can figure out devshells lol
    go
    lua

    # gotools
    # golangci-lint
    inputs.nixvim.packages."x86_64-linux".default
    inputs.zen-browser.packages."x86_64-linux".default
  ];
}
