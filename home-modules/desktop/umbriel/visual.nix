# Run `umbriel windows` to see live app_ids and titles to match against.

{ ... }: {
  programs.umbriel = {
    settings = {

      layout = {
        gap = 6;
      };

      appearance = {
        corner_radius = 18;
        border_width = 3;
        outer_border_width = 2;
        blur = {
          enabled = true;
          passes = 3;
          radius = 6;
          noise = 0.06;
          brightness = 0.9;
          contrast = 0.9;
          saturation = 1.1;
        };
        shadow = {
          enabled = true;
          softness = 8;
          offset_x = 2;
          offset_y = 2;
        };
      };

      # --- Window Rules
      # Documentation: https://docs.noctalia.dev/umbriel/window-rules/

      window_rule = [
        {
          # Default Rule for All windows unless otherwise overruled
          blur = true;
          opacity = 0.90;
          default_floating_size = {
            width = 0.4;
            height = 0.6;
          };
          default_position = {
            x = 0;
            y = 0;
            anchor = "center";
          };
        }

        # - unfocused windows drop to 75% opacity
        {
          match = {
            is_focused = false;
          };
          opacity = 0.75;
        }

        # Default Floating
        {
          default_floating = true;
          opacity = 1;

          # Nemo Properties Window, umbriel share picker, file roller, materialgram media, image viewer, zen extensions
          # must amtch both app_id and title.
          match = {
            app_id = [
              "nemo"
              "UmbrielSharePicker$"
              "FileRoller$"
              "materialgram$"
              "Loupe$"
              "zen"
            ];
            title = [
              "Properties$"
              "^Media"
              "^Extension"
              "^Share"
            ];
          };
        }

        {
          match = {
            app_id = "^kitty";
          };
          opacity = 0.75;
        }
        # Zen Picture in Picture
        {
          match = {
            app_id = "zen";
            title = "^Picture-in-Picture";
          };
          default_floating = true;
          default_floating_size = {
            width = 0.4;
            height = 0.4;
          };
          opacity = 1;
          default_position = {
            x = 16;
            y = 16;
            anchor = "bottom_right";
          };
        }

        #Handbrake
        {
          match = {
            app_id = "^fr\\.handbrake\\.ghb$";
            title = "^(?!HandBrake$)"; # everything but the main window
          };
          default_floating = true;
        }

        # Steam Games; default maximized to main monitor
        {
          match = {
            app_id = [
              "^steam_app"
              "^[Xwayland] Minecraft"
            ];
          };
          default_floating = false;
          default_output = "HP Inc. OMEN 27q CNC43225MX";
          default_maximize = true;

          opacity = 1;
        }

      ];
    };
  };
}
