# --- Umbriel regex reference (window_rule match.app_id / match.title / match.xdg_tag)
#
# Engine: C++ std::regex, ECMAScript flavour (like JavaScript regex), case-sensitive.
#   - Uses regex_search, so a pattern matches ANY part of the value.
#     Anchor with ^ and $ for an exact match:  "^kitty$"
#   - `.` is "any single character", not a literal dot. Escape it for a literal:
#     in Nix strings that means a double backslash: "^fr\\.handbrake\\.ghb$"
#     ("^.foo" means "exactly one char, then foo" -- almost never what you want)
#   - No `!` negation prefix. "!foo" is just a literal "!". To exclude, use a
#     negative lookahead:  "^(?!HandBrake$)"  = any title except exactly "HandBrake"
#                          "^(?!.*Settings)"  = any title not containing "Settings"
#   - No lookbehind (?<=...), no inline flags like (?i). For case-insensitivity
#     use a character class: "[Hh]and[Bb]rake"
#   - A list of patterns matches if ANY of them match: app_id = [ "^mpv$" "^celluloid$" ];
#   - Selectors within one `match` are ANDed (app_id AND title must both match).
#   - Invalid patterns don't fail the build; umbriel logs "invalid regex in ..." at load.
#
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
          opacity = 0.85;
          default_floating_size = {
            width = 0.4;
            height = 0.6;
          };

        }
        {
          match = {
            app_id = "^kitty";
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

        # Image Viewer
        {
          match = {
            app_id = ".Loupe$";
          };
          default_floating = true;
          opacity = 1;
        }
        {
          match = {
            app_id = ".FileRoller$";
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
            height = 0.55;
          };
          default_position = {
            x = 0;
            y = 0;
            anchor = "center";
          };
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
          default_position = {
            x = 16;
            y = 16;
            anchor = "bottom_right";
          };
        }
        # Umbriel share selecter
        {
          match = {
            app_id = ".SharePicker$";
          };
          default_floating = true;
        }

        # Materialgram media viewer
        {
          match = {
            app_id = ".materialgram$";
            title = "^Media.";
          };
          default_floating = true;
          default_position = {
            x = 0;
            y = 0;
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

        # Steam Games
        {
          # TODO: test if works
          match = {
            app_id = "^.steam_app.";
          };
          default_floating = false;
          default_maximize = true;

          opacity = 1;
        }

      ];
    };
  };
}
