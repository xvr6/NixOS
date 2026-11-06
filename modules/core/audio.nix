{ ... }:
{
  # [Claude assisted research, code written by me.]
  # Audeze Maxwell dongle (3329:4b18): separate Game (hw:X,1) and Chat (hw:X,0) sinks so the balance dial works.
  # Based on pipewire's usb-gaming-headset.conf, but each sink gets its own mixer element (upstream uses "PCM,1" for both).
  # Ref: https://bbs.archlinux.org/viewtopic.php?id=309552; inspect elements with `amixer -c <card> contents`.
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
          # Keep streams on their sink when the default changes (else Vesktop gets dragged from Chat to Game).
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
                "priority.session" = 1000; # select this as Vesktop's output device
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
        #"10-airplay" = {
        #  "context.modules" = [
        #    {
        #      name = "libpipewire-module-raop-discover";
        #      args = {
        #        # "raop.latency.ms" = 500; # raise on dropouts
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
