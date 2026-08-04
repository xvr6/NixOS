{
  self,
  inputs,
  ...
}:
{
  # ─── NixOS System Module ─────────────────────────────────────────────────────
  flake.nixosModules.niri = { pkgs, lib, ... }: {

    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };

    xdg.portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
      config.common.default = [
        "gnome"
        "gtk"
      ];
    };

    environment.variables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "niri";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GDK_BACKEND = "wayland,x11,*";
      MOZ_ENABLE_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland;xcb";
    };
  };

  # ─── Niri Package (wrapper-modules) ──────────────────────────────────────────
  perSystem =
    {
      pkgs,
      lib,
      self',
      ...
    }:
    {
      packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {

          # ── Startup ────────────────────────────────────────────────────────────
          spawn-at-startup = [
            (lib.getExe self'.packages.myNoctalia)
          ];

          "prefer-no-csd" = _: { };

          # ── Environment ────────────────────────────────────────────────────────
          environment = {
            ELECTRON_OZONE_PLATFORM_HINT = "auto";
            QT_QPA_PLATFORM = "wayland";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            XDG_SESSION_TYPE = "wayland";
            XDG_CURRENT_DESKTOP = "niri";
            SDL_VIDEODRIVER = "wayland";
            GDK_BACKEND = "wayland,x11,*";
            MOZ_ENABLE_WAYLAND = "1";
          };

          # ── Input ──────────────────────────────────────────────────────────────
          input = {
            keyboard = {
              xkb.layout = "us,ua";
              "repeat-delay" = 275;
              "repeat-rate" = 35;
              numlock = _: { };
            };
          };

          # ── Output ─────────────────────────────────────────────────────────────
          outputs."eDP-1" = {
            scale = 1.5;
          };

          # ── Layout ─────────────────────────────────────────────────────────────
          layout = {
            gaps = 8;
            "focus-ring" = {
              width = 2;
              "active-gradient" = _: {
                props = {
                  from = "#ca9ee6ff";
                  to = "#f2d5cfff";
                  angle = 45;
                };
              };
              "inactive-gradient" = _: {
                props = {
                  from = "#b4befecc";
                  to = "#6c7086cc";
                  angle = 45;
                };
              };
            };
          };

          # ── Animations ─────────────────────────────────────────────────────────
          animations = {
            slowdown = 1.0;
            "workspace-switch" = {
              spring = _: {
                props = {
                  "damping-ratio" = 0.8;
                  stiffness = 800;
                  epsilon = 0.0001;
                };
              };
            };
            "horizontal-view-movement" = {
              spring = _: {
                props = {
                  "damping-ratio" = 0.8;
                  stiffness = 800;
                  epsilon = 0.0001;
                };
              };
            };
            "window-movement" = {
              spring = _: {
                props = {
                  "damping-ratio" = 0.9;
                  stiffness = 800;
                  epsilon = 0.0001;
                };
              };
            };
            "window-open" = {
              "duration-ms" = 200;
              curve = "ease-out-expo";
            };
            "window-close" = {
              "duration-ms" = 150;
              curve = "ease-out-expo";
            };
          };

          # ── Window Rules ───────────────────────────────────────────────────────
          window-rules = [

            # Global corner rounding
            {
              "geometry-corner-radius" = 10.0;
              "clip-to-geometry" = true;
            }

            # Browsers — fully opaque
            {
              matches = [
                { app-id = "^(firefox|Brave-browser|floorp|zen|zen-beta)$"; }
              ];
              opacity = 1.0;
            }

            # 0.90 opacity
            {
              matches = [
                { app-id = "^gcr-prompter$"; }
                { app-id = "^obsidian$"; }
                { app-id = "^(Lutris|lutris|net\\.lutris\\.Lutris)$"; }
                { app-id = "^discord$"; }
                { app-id = "^WebCord$"; }
                { app-id = ".*materialgram.*"; }
                { app-id = ".*youtube_music.*"; }
              ];
              opacity = 0.90;
            }

            # 0.80 opacity
            {
              matches = [
                { app-id = "^(kitty|alacritty|Alacritty|org\\.wezfurlong\\.wezterm)$"; }
                { app-id = "^nvim-wrapper$"; }
                { app-id = "^gnome-disks$"; }
                { app-id = "^thunar-volman-settings$"; }
                { app-id = "^org\\.gnome\\.FileRoller$"; }
                { app-id = "^io\\.github\\.ilya_zlobintsev\\.LACT$"; }
                { app-id = "^(Steam|steam|steamwebhelper)$"; }
                { app-id = "^(Spotify|spotify)$"; }
                { app-id = "^(VSCodium|codium-url-handler)$"; }
                { app-id = "^(code|code-url-handler)$"; }
                { app-id = "^tuiFileManager$"; }
                { app-id = "^org\\.kde\\.dolphin$"; }
                { app-id = "^org\\.kde\\.ark$"; }
                { app-id = "^nwg-look$"; }
                { app-id = "^(qt5ct|qt6ct)$"; }
                { app-id = "^yad$"; }
                { app-id = "^hu\\.kramo\\.Cartridges$"; }
                { app-id = "^com\\.obsproject\\.Studio$"; }
                { app-id = "^gnome-boxes$"; }
                { app-id = "^app\\.drey\\.Warp$"; }
                { app-id = "^net\\.davidotek\\.pupgui2$"; }
                { app-id = "^Signal$"; }
                { app-id = "^io\\.gitlab\\.theevilskeleton\\.Upscaler$"; }
                { app-id = "^(pavucontrol|org\\.pulseaudio\\.pavucontrol)$"; }
                { app-id = "^\\.?blueman-manager(-wrapped)?$"; }
                { app-id = "^(nm-applet|nm-connection-editor)$"; }
                { app-id = "^org\\.kde\\.polkit-kde-authentication-agent-1$"; }
              ];
              opacity = 0.80;
            }
            {
              matches = [ { title = "^Kvantum Manager$"; } ];
              opacity = 0.80;
            }
            {
              matches = [ { title = ".*Spotify.*"; } ];
              opacity = 0.80;
            }

            # Games — fullscreen, full opacity
            {
              matches = [
                { app-id = "^steam_app_.*"; }
                { app-id = "^gamescope$"; }
                { app-id = "^osu!$"; }
              ];
              "open-fullscreen" = true;
              opacity = 1.0;
            }

            # Float rules
            {
              matches = [
                { app-id = "^qt5ct$"; }
                { app-id = "^nwg-look$"; }
                { app-id = "^org\\.kde\\.ark$"; }
                { app-id = "^Signal$"; }
                { app-id = "^com\\.github\\.rafostar\\.Clapper$"; }
                { app-id = "^app\\.drey\\.Warp$"; }
                { app-id = "^net\\.davidotek\\.pupgui2$"; }
                { app-id = "^eog$"; }
                { app-id = "^io\\.gitlab\\.theevilskeleton\\.Upscaler$"; }
                { app-id = "^yad$"; }
                { app-id = "^pavucontrol$"; }
                { app-id = "^\\.?blueman-manager(-wrapped)?$"; }
                { app-id = "^(nm-applet|nm-connection-editor)$"; }
                { app-id = "^org\\.kde\\.polkit-kde-authentication-agent-1$"; }
              ];
              "open-floating" = true;
            }

            # Picture-in-Picture
            {
              matches = [ { title = "^Picture-in-Picture$"; } ];
              "open-floating" = true;
            }

            # materialgram Media/Instant View — float and full opacity
            {
              matches = [
                {
                  title = ".*Media viewer.*";
                  app-id = ".*materialgram.*";
                }
                {
                  title = ".*Instant View.*";
                  app-id = ".*materialgram.*";
                }
              ];
              "open-floating" = true;
              opacity = 1.0;
            }

            # Zen browser extension windows
            {
              matches = [
                {
                  title = ".*Extension.*";
                  app-id = "^zen$";
                }
              ];
              "open-floating" = true;
            }

          ];

          # ── Keybinds ───────────────────────────────────────────────────────────
          binds = {

            # --- Compositor ---
            "Mod+Shift+Escape".show-hotkey-overlay = [ ];

            # --- Applications ---
            "Mod+Return".spawn-sh = lib.getExe self'.packages.myKitty;
            "Mod+Space".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
            "Mod+Ctrl+Return".spawn-sh = "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";
            "Mod+B".spawn = [ "firefox" ];
            "Mod+E".spawn = [ "thunar" ];
            "Mod+Alt+L".spawn = [ "swaylock" ];

            # --- Audio ---
            "XF86AudioRaiseVolume" = {
              allow-when-locked = true;
              spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1+"
              ];
            };
            "XF86AudioLowerVolume" = {
              allow-when-locked = true;
              spawn = [
                "wpctl"
                "set-volume"
                "@DEFAULT_AUDIO_SINK@"
                "0.1-"
              ];
            };
            "XF86AudioMute" = {
              allow-when-locked = true;
              spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SINK@"
                "toggle"
              ];
            };
            "XF86AudioMicMute" = {
              allow-when-locked = true;
              spawn = [
                "wpctl"
                "set-mute"
                "@DEFAULT_AUDIO_SOURCE@"
                "toggle"
              ];
            };

            # --- Window: Close ---
            "Mod+Q".close-window = [ ];

            # --- Window: Focus ---
            "Mod+Left".focus-column-left = [ ];
            "Mod+H".focus-column-left = [ ];
            "Mod+Right".focus-column-right = [ ];
            "Mod+L".focus-column-right = [ ];
            "Mod+Up".focus-window-up = [ ];
            "Mod+K".focus-window-up = [ ];
            "Mod+Down".focus-window-down = [ ];
            "Mod+J".focus-window-down = [ ];

            "Mod+Home".focus-column-first = [ ];
            "Mod+End".focus-column-last = [ ];

            "Mod+Shift+Left".focus-monitor-left = [ ];
            "Mod+Shift+Right".focus-monitor-right = [ ];
            "Mod+Shift+Up".focus-monitor-up = [ ];
            "Mod+Shift+Down".focus-monitor-down = [ ];

            # --- Window: Move ---
            "Mod+Ctrl+Left".move-column-left = [ ];
            "Mod+Ctrl+H".move-column-left = [ ];
            "Mod+Ctrl+Right".move-column-right = [ ];
            "Mod+Ctrl+L".move-column-right = [ ];
            "Mod+Ctrl+Up".move-window-up = [ ];
            "Mod+Ctrl+K".move-window-up = [ ];
            "Mod+Ctrl+Down".move-window-down = [ ];
            "Mod+Ctrl+J".move-window-down = [ ];

            "Mod+Ctrl+Home".move-column-to-first = [ ];
            "Mod+Ctrl+End".move-column-to-last = [ ];

            "Mod+Shift+Ctrl+Left".move-column-to-monitor-left = [ ];
            "Mod+Shift+Ctrl+Right".move-column-to-monitor-right = [ ];
            "Mod+Shift+Ctrl+Up".move-column-to-monitor-up = [ ];
            "Mod+Shift+Ctrl+Down".move-column-to-monitor-down = [ ];

            # --- Workspaces: Focus ---
            "Mod+Tab".focus-workspace-previous = [ ];

            "Mod+1".focus-workspace = 1;
            "Mod+2".focus-workspace = 2;
            "Mod+3".focus-workspace = 3;
            "Mod+4".focus-workspace = 4;
            "Mod+5".focus-workspace = 5;
            "Mod+6".focus-workspace = 6;
            "Mod+7".focus-workspace = 7;
            "Mod+8".focus-workspace = 8;
            "Mod+9".focus-workspace = 9;

            # --- Workspaces: Move Column ---
            "Mod+Ctrl+1".move-column-to-workspace = 1;
            "Mod+Ctrl+2".move-column-to-workspace = 2;
            "Mod+Ctrl+3".move-column-to-workspace = 3;
            "Mod+Ctrl+4".move-column-to-workspace = 4;
            "Mod+Ctrl+5".move-column-to-workspace = 5;
            "Mod+Ctrl+6".move-column-to-workspace = 6;
            "Mod+Ctrl+7".move-column-to-workspace = 7;
            "Mod+Ctrl+8".move-column-to-workspace = 8;
            "Mod+Ctrl+9".move-column-to-workspace = 9;

            # --- Scroll: Workspace ---
            "Mod+WheelScrollDown" = {
              cooldown-ms = 150;
              focus-workspace-down = [ ];
            };
            "Mod+WheelScrollUp" = {
              cooldown-ms = 150;
              focus-workspace-up = [ ];
            };
            "Mod+Ctrl+WheelScrollDown" = {
              cooldown-ms = 150;
              move-column-to-workspace-down = [ ];
            };
            "Mod+Ctrl+WheelScrollUp" = {
              cooldown-ms = 150;
              move-column-to-workspace-up = [ ];
            };

            # --- Scroll: Column ---
            "Mod+WheelScrollRight".focus-column-right = [ ];
            "Mod+WheelScrollLeft".focus-column-left = [ ];
            "Mod+Ctrl+WheelScrollRight".move-column-right = [ ];
            "Mod+Ctrl+WheelScrollLeft".move-column-left = [ ];

            "Mod+Shift+WheelScrollDown".focus-column-right = [ ];
            "Mod+Shift+WheelScrollUp".focus-column-left = [ ];
            "Mod+Ctrl+Shift+WheelScrollDown".move-column-right = [ ];
            "Mod+Ctrl+Shift+WheelScrollUp".move-column-left = [ ];

            # --- Layout ---
            "Mod+Ctrl+F".expand-column-to-available-width = [ ];
            "Mod+C".center-column = [ ];
            "Mod+Ctrl+C".center-visible-columns = [ ];
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            # --- Window Mode ---
            "Mod+T".toggle-window-floating = [ ];
            "Mod+F".fullscreen-window = [ ];
            "Mod+W".toggle-column-tabbed-display = [ ];

            # --- Screenshots ---
            "Ctrl+Shift+1".screenshot = [ ];
            "Ctrl+Shift+2".screenshot-screen = [ ];
            "Ctrl+Shift+3".screenshot-window = [ ];

            # --- Special ---
            "Mod+Escape" = {
              allow-inhibiting = false;
              toggle-keyboard-shortcuts-inhibit = [ ];
            };
            "Mod+Shift+P".power-off-monitors = [ ];
            "Mod+O" = {
              repeat = false;
              toggle-overview = [ ];
            };

          };

        };
      };
    };
}
