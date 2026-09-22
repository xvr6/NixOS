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
          blur = true;
          opacity = 0.90;
        }
        {
          match = {
            app_id = "kitty";
          };
          opacity = 0.75;
        }

        # Nemo Properties Window
        {
          match = {
            app_id = "nemo";
            title = ".Properties$";
          };
          default_floating = true;
        }

        # Any extension from Zen
        {
          match = {
            app_id = "zen";
            title = "^Extension.";
          };
          default_floating = true;
          default_floating_size = {
            width = 0.30;
            height = 0.45;
          };
          default_position = {
            x = 0;
            y = 0;
            anchor = "center";
          };
        }
        # Materialgram media viewer
        {
          match = {
            app_id = ".materialgram$";
            title = ".Media Viewer.";
          };
          default_floating = true;
          default_position = {
            x = 0;
            y = 0;
          };
        }

        # Steam Games
        { # TODO: test if works
          match = {
            app_id = ".steam_app.";
          };
          default_floating = false;
          default_maximize = true;

          opacity = 1;
        }

      ];
    };
  };
}
