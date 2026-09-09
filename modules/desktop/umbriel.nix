{ config, pkgs, ... }: {

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

        "Mod+Return" = "spawn:kitty";
        "Mod+Q" = "window-close";
        "Mod+W" = "window-toggle-maximize";
        "Mod+F" = "window-toggle-floating";
        "Mod+H" = "cheatsheet-toggle";
      };
    };
  };
}
