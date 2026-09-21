{ config, pkgs, ... }: {
  # other components of umbriel config
  imports = [
    ./binds.nix
    ./visual.nix
  ];

  programs.umbriel = {
    enable = true;

    settings = {
      general = {
        autostart = [
          "noctalia"
          "kitty"
        ];
        xwayland = true;
        show_cheatsheet = true; # shows on boot
      };
      overview = {
        zoom = 0.5; # 0.1-0.75
        scroll_factor_horizontal = 1.0; # 0.1-10.0
        scroll_factor_vertical = 1.0; # 0.1-10.0
        background_blur = true;
        workspace_wallpaper = true;
        shortcuts = true;
        shortcut_keys = "1234567890";
      };
      events.lid_close = "";
      output = {
        "eDP-1" = {
          # nixwork laptop display
          mode = "2880x1920@120";
          scale = 1.25;
        };

        # nixtop displays
        "HP Inc. OMEN 27q CNC43225MX" = {
          mode = "2560x1440@165";
          scale = 1;
        };
        "Sceptre Tech Inc Sceptre M25 Unknown" = {
          mode = "1920x1080@165";
          scale = 1;
          position = [
            (-1920)
            0
          ]; # [x y]
        };
      };
      layout = {
        gap = 6;
      };

      input = {
        focus.follows_mouse = true;
        middle_click_paste = false;
        cursor = {
          theme = "";
          size = 24;
          hardware_cursor = true;
          follows_focus = true; # snapping to  window when focus changes.
        };
        keyboard = {
          layout = "us";
          repeat_rate = 40;
          repeat_delay = 250;
        };
      };

    };
  };
}
