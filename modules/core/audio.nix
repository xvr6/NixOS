{ pkgs, ... }:
{
  # [Claude assisted research, code written by me.]
  # -- Audeze Maxwell game/chat mix
  # The dongle exposes two playback PCMs (hw:X,0 = chat + mic, hw:X,1 = game) and mixes
  # them in hardware using the headset's balance dial. By default ACP only creates a
  # single "Analog Stereo" sink on PCM 0, so the dial does nothing useful. A custom ACP
  # profile set creates separate Game and Chat sinks.
  # 3329:4b18 = Audeze Maxwell XBOX Dongle
  #
  # PipeWire's bundled usb-gaming-headset.conf (Arctis 7, Astro A50, ...) almost works, but
  # its stereo output path is hardcoded to the "PCM,1" mixer element. The Maxwell's chat
  # PCM is stereo too, so both sinks drove the *game* hardware volume and the chat one
  # ("PCM", index 0) was never touched -> volumes desynced/jumped depending on the sink.
  # The paths below bind each sink to its own element. ACP checks
  # /etc/alsa-card-profile/mixer/ (and ~/.config/alsa-card-profile/mixer/) before its
  # built-in dir.
  #   Game: hw:X,1 -> "PCM Playback Volume",1    Chat: hw:X,0 -> "PCM Playback Volume"
  #   Mic:  hw:X,0 -> "Mic Capture Volume" (stock input path expects a "Headset" element)
  # Sources:
  #   https://bbs.archlinux.org/viewtopic.php?id=309552 (PCM mapping + udev ACP_PROFILE_SET)
  #   https://discussion.fedoraproject.org/t/audeze-maxwell-headset-media-keys-doesnt-work-without-keeping-pavucontrol-open-with-the-pro-audio-profile-selected/127850 (pro-audio alternative)
  #   Based on: ${pkgs.pipewire}/share/alsa-card-profile/mixer/profile-sets/usb-gaming-headset.conf
  #   Upstream device list: ${pkgs.pipewire}/lib/udev/rules.d/90-pipewire-alsa.rules
  #   Mixer elements: `amixer -c <card> contents`, /proc/asound/<card>/usbmixer
  services.udev.extraRules = ''
    SUBSYSTEM=="sound", ACTION=="change", KERNEL=="card*", ATTRS{idVendor}=="3329", ATTRS{idProduct}=="4b18", ENV{ACP_PROFILE_SET}="audeze-maxwell.conf"
  '';

  environment.etc =
    let
      outputPath = element: ''
        [General]
        description-key = analog-output-headphones

        [Element ${element}]
        volume = merge
        switch = mute
        override-map.1 = all
        override-map.2 = all-left,all-right
      '';
    in
    {
      "alsa-card-profile/mixer/paths/audeze-maxwell-game.conf".text = outputPath "PCM,1";
      "alsa-card-profile/mixer/paths/audeze-maxwell-chat.conf".text = outputPath "PCM";
      "alsa-card-profile/mixer/paths/audeze-maxwell-mic.conf".text = ''
        [General]
        description-key = analog-input-microphone-headset

        [Element Mic]
        volume = merge
        switch = mute
        override-map.1 = all
        override-map.2 = all-left,all-right
      '';
      "alsa-card-profile/mixer/profile-sets/audeze-maxwell.conf".text = ''
        [General]
        auto-profiles = no

        [Mapping stereo-game]
        description-key = gaming-headset-game
        device-strings = hw:%f,1,0
        channel-map = left,right
        paths-output = audeze-maxwell-game
        direction = output

        [Mapping stereo-chat]
        description-key = gaming-headset-chat
        device-strings = hw:%f,0,0
        channel-map = left,right
        paths-output = audeze-maxwell-chat
        direction = output
        intended-roles = phone

        [Mapping mono-chat]
        description-key = gaming-headset-chat
        device-strings = hw:%f,0,0
        channel-map = mono
        paths-input = audeze-maxwell-mic
        direction = input
        intended-roles = phone

        [Profile output:stereo-game+output:stereo-chat+input:mono-chat]
        description = Game + Chat
        output-mappings = stereo-game stereo-chat
        input-mappings = mono-chat
        priority = 5100
      '';
    };

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      # jack.enable = true;
      wireplumber = {
        enable = true;
        extraConfig."51-audeze-maxwell" = {
          # A stream pinned to a sink that happened to be the default when it linked (e.g.
          # Discord -> Chat while Chat was selected to adjust its volume) would otherwise be
          # dragged along to the next default (Game) and inherit its volume.
          "wireplumber.settings"."linking.follow-default-target" = false;
          "monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "~alsa_output.usb-Audeze_LLC_Audeze_Maxwell_.*\\.stereo-game"; } ];
              actions.update-props = {
                "node.description" = "Audeze Maxwell Game";
                "node.nick" = "Maxwell Game";
                "device.form-factor" = "headphones";
                "priority.session" = 1100; # default sink for everything
              };
            }
            {
              matches = [
                { "node.name" = "~alsa_output.usb-Audeze_LLC_Audeze_Maxwell_.*\\.(stereo|mono)-chat"; }
              ];
              actions.update-props = {
                "node.description" = "Audeze Maxwell Chat";
                "node.nick" = "Maxwell Chat";
                "device.form-factor" = "headset";
                "priority.session" = 1000; # select this as Discord's output device
              };
            }
            {
              matches = [ { "node.name" = "~alsa_input.usb-Audeze_LLC_Audeze_Maxwell_.*"; } ];
              actions.update-props = {
                "node.description" = "Audeze Maxwell Mic";
                "node.nick" = "Maxwell Mic";
              };
            }
          ];
        };
      };

      # Airplay/RAOP
      # raopOpenFirewall = true;
      extraConfig.pipewire = {
        #"10-airplay" = {   #-- copy-pasted from some thread, refind to learn more.
        #  "context.modules" = [
        #    {
        #      name = "libpipewire-module-raop-discover";
        #      args = {
        #        # "raop.latency.ms" = 500; #If lag/dropouts occur, try increasing buffer.
        #      };
        #    }
        #  ];
        #};
        "92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 2048;
          };
        };
      };
    };
  };
}
