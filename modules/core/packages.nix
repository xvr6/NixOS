{ inputs, pkgs, ... }:
let
  zenPkgs = inputs.zen-browser.packages."x86_64-linux";

  # The zen flake still sets the old `ffmpegSupport`/`gssSupport` passthru names,
  # but nixpkgs wrapFirefox now reads `withFFmpeg`/`withGSSAPI`/`withPipewire`.
  # Without them ffmpeg never lands on LD_LIBRARY_PATH (no H.264/AAC playback).
  zen-browser = zenPkgs.zen-browser.override {
    zen-browser-unwrapped = zenPkgs.zen-browser-unwrapped.overrideAttrs (old: {
      passthru = old.passthru // {
        withFFmpeg = true;
        withGSSAPI = true;
        withPipewire = true;
      };
    });
  };
in
{
  imports = [
    # imported flake packages
    inputs.noctalia.nixosModules.default
    inputs.noctalia-greeter.nixosModules.default
    inputs.umbriel.nixosModules.default
  ];

  programs = {
    noctalia = {
      enable = true;
      # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
      recommendedServices.enable = true;
    };
    umbriel.enable = true;
    # Registers the Umbriel session with the display manager
    # (greeters dont pick up home manager)

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
    #    "ventoy-*"
  ];

  environment.systemPackages = with pkgs; [
    # --- Flake imports and manually defined packages
    inputs.nixvim.packages."x86_64-linux".default
    zen-browser

    # --- Packages
    handbrake
    #TODO: Move out this mess into files its prevelant to. I.e move all noctalia stuff to noctalia file.
    firefox
    # -- Noctalia + Addons
    yt-dlp
    # mpv-mpris is wired in via `scripts` so mpv actually loads it and exposes
    # MPRIS on the session bus (just installing mpvScripts.mpris alongside
    # mpv does nothing - mpv only loads scripts passed via --script).
    (mpv.override { scripts = [ mpvScripts.mpris ]; }) # video player, also needed for addons; exposes MPRIS for e.g. the yt-music noctalia plugin

    ##Anything below must be vetted for usage.

    lshw
    _7zz # current 7zip
    file-roller # needed for thunar
    #ventoy
    gnumake
    appimage-run # Needed For AppImage Support
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    rclone # Cloning Utility
    jq # Json Formatting Utility
    bibata-cursors
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
    libnotify # For Notifications
    lolcat # Add Colors To Your Terminal Command Output
    # lshw # Detailed Hardware Information
    picard # For Changing Music Metadata & Getting Cover Art
    # pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    # rhythmbox # audio player
    # socat # Needed For Screenshots
    # usbutils # Good Tools For USB Devices
    # uwsm # Universal Wayland Session Manager (optional must be enabled)
    v4l-utils # Used For Things Like OBS Virtual Camera
    wget # Tool For Fetching Files With Links
    ytmdl # Tool For Downloading Audio From YouTube

    gcc

    btop
    # devenv
    # devbox
    # shellify

    #NOTE: these imports are here until i can figure out devshells lol
    go
    lua

    # gotools
    # golangci-lint
  ];
}
