{ config, pkgs, ... }: {
  # Home Module
  programs.umbriel = {
    enable = true;

    settings = {
      general = {
        autostart = [ "noctalia" ];
        xwayland = true;
      };
      appearance = {
        corner_radius = 15;
        border_width = 4;
        outer_border_width = 0;

        blur = {
          enabled = true;
          passes = 3;
          radius = 3;
          noise = 0.02;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };
        shadow = {
          enabled = true;
          softness = 10;
          offset_x = 2;
          offset_y = 2;
        };
      };
      events.lid_close = "";
      output = {
        "eDP-1" = {
          # nixtop display
          mode = "2880x1920@120";
          scale = 1.25;
        };

        "HP Inc. OMEN 27q CNC43225MX" = { };
        "Sceptre Tech Inc Sceptre M25 Unknown" = { };
      };
      layout = {
        gap = 5;
      };

      input = {
        focus.follows_mouse = true;
        cursor = {

        };
        keyboard = {
          layout = "us";
          repeat_rate = 40;
          repeat_delay = 250;
        };
      };

      keybinds = {
        # noctalia
        "Mod+Space" = "spawn: noctalia msg panel-toggle launcher";
        "Mod+L" = "spawn: noctalia ipc call lockScreen lock";

        # System
        "XF86MonBrightnessUp" = "spawn: noctalia msg brightness-up 5";
        "XF86MonBrightnessDown" = "spawn: noctalia msg brightness-down 5";
        "XF86AudioRaiseVolume" = "spawn: noctalia msg volume-up 5";
        "XF86AudioLowerVolume" = "spawn: noctalia msg volume-down 5";
        "XF86AudioMute" = "spawn: noctalia msg volume-mute";

        "XF86AudioPlay" = "spawn: noctalia msg media toggle";
        "XF86AudioNext" = "spawn: noctalia msg media next";
        "XF86AudioPrev" = "spawn: noctalia msg media previous";
        "Print" = "spawn: noctalia msg screenshot-annotate";
        #show clipboard
        "Mod+V" = "spawn: noctalia msg panel-toggle clipboard";

        # programs
        "Mod+Return" = "spawn:kitty";
        "Mod+E" = "spawn:yazi";

        #Umbriel Keybinds
        "Mod+Q" = "window-close";
        "Mod+W" = "window-toggle-floating";
        "Mod+F" = "window-toggle-maximize";
        "Mod+H" = "cheatsheet-toggle";
      };
    };
  };
}
