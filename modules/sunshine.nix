# Sunshine game-stream host. Import from a host to enable it; it starts at
# boot (no login needed) so Moonlight can connect straight to the greeter.
{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.sunshine = {
    enable = true;
    capSysAdmin = true; # required for KMS capture
    openFirewall = true;
    # started at boot below instead of with the graphical session
    autoStart = false;

    # default build lacks CUDA, so NVENC fails and it falls back to software x264
    package = pkgs.sunshine.override {
      cudaSupport = lib.elem "nvidia" config.services.xserver.videoDrivers;
    };

    # Declaring settings/applications makes the web UI config read-only.
    # Pairing state and credentials still live in ~/.config/sunshine.
    settings = {
      upnp = "on";
      address_family = "both";
      nvenc_twopass = "full_res";
      # KMS grabs the DRM framebuffer directly, so it can stream the greeter
      # before anyone logs in and keeps working across login/logout.
      # (umbriel's portal also lacks the RemoteDesktop interface portalgrab needs)
      capture = "kms";
    };

    applications = {
      env.PATH = "$(PATH):$(HOME)/.local/bin";
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
        }
        {
          name = "Steam Big Picture";
          # systemd-run picks up the session's WAYLAND_DISPLAY/DISPLAY from the
          # user manager, which sunshine was started before
          detached = [ "systemd-run --user steam steam://open/bigpicture" ];
          prep-cmd = [
            {
              do = "";
              undo = "systemd-run --user steam steam://close/bigpicture";
            }
          ];
          image-path = "steam.png";
        }
      ];
    };
  };

  # start the user manager at boot so sunshine runs without a login
  users.users.xvr6.linger = true;
  systemd.user.services.sunshine = {
    wantedBy = [ "default.target" ];
    partOf = lib.mkForce [ ];
    wants = lib.mkForce [ ];
    after = lib.mkForce [ ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      47984
      47989
      47990 # webui
      48010
    ];
    allowedUDPPorts = [
      47998
      47999
      48000
    ];
  };
}
