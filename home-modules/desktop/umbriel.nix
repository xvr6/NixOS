{ config, pkgs, ... }: {
  # Home Module
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
      appearance = {
        corner_radius = 15;
        border_width = 4;
        outer_border_width = 0;

        blur = {
          enabled = true;
          passes = 3;
          radius = 6;
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
            (1080 - 1440)
          ]; # [x y]
        };
      };
      layout = {
        gap = 5;
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

      keybinds = {
        # With keybinds, control is for anything local, shift is for anything workspace/layout based.
        # i.e: mod+control modifies the active window; mod+shift modifies workspaces (move window to x workspace, etc)

        # Noctalia
        "Mod+Space" = "spawn: noctalia msg panel-toggle launcher";
        "Mod+L" = "spawn: noctalia ipc call lockScreen lock";

        # - System
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
        #Yputube Music Noctalia Plugin
        "Mod+M" = "spawn: noctalia msg panel-toggle aabidk20/yt-music:panel";

        # Programs
        "Mod+Return" = "spawn: kitty";
        "Mod+E" = "spawn:kitty yazi";
        "Mod+Shift+Escape" = "spawn:kitty btop";
        "Mod+B" = "spawn: zen";

        #Umbriel window management
        "Mod+Q" = "window-close";
        "Mod+W" = "window-toggle-floating";
        "Mod+F" = "window-cycle-primary-extent";
        "Mod+Shift+F" = "window-toggle-fullscreen";
        "Mod+Control+F" = "window-toggle-maximize";
        "Mod+P" = "window-toggle-pinned";
        "F11" = "window-toggle-fullscreen";

        # Focus & Window Positions
        "Mod+Left" = "window-focus-left";
        "Mod+WheelLeft" = "window-focus-left";
        "Mod+Control+Left" = "column-move-left";
        "Mod+Control+WheelLeft" = "column-move-left";
        "Mod+Shift+Left" = "column-move-to-output-left";
        "Mod+Shift+WheelLeft" = "column-move-to-output-left";

        "Mod+Right" = "window-focus-right";
        "Mod+WheelRight" = "window-focus-right";
        "Mod+Control+Right" = "column-move-right";
        "Mod+Control+WheelRight" = "column-move-right";
        "Mod+Shift+Right" = "column-move-to-output-right";
        "Mod+Shift+WheelRight" = "column-move-to-output-right";

        "Mod+Down" = "workspace-next";
        "Mod+WheelDown" = "workspace-next";
        "Mod+Shift+Down" = "window-move-to-workspace-next";
        "Mod+Shift+WheelDown" = "window-move-to-workspace-next";

        "Mod+Up" = "workspace-previous";
        "Mod+WheelUp" = "workspace-previous";
        "Mod+Shift+Up" = "window-move-to-workspace-previous";
        "Mod+Shift+WheelUp" = "window-move-to-workspace-previous";

        # - Misc
        "Mod+H" = "cheatsheet-toggle";
      };
      window_rule = [
        {
          blur = true;
          opacity = 0.90;
        }
        {
          match = {
            app_id = "kitty";
          };
          opacity = 0.70;
        }
      ];
    };
  };
}
