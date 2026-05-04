{
  host,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (import ../../../hosts/${host}/variables.nix)
    waybarTheme
    browser
    terminal
    tuiFileManager
    defaultWallpaper
    ;
in
{
  imports = [
    ./submodules/noctalia
  ];

  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  services.displayManager.defaultSession = "hyprland";

  systemd.user.services.hyprpolkitagent = {
    description = "Hyprpolkitagent - Polkit authentication agent";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    # ... maybe other stuff
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };

  home-manager.sharedModules =
    let
      inherit (lib) getExe getExe';
    in
    [
      (
        { config, ... }:
        {
          xdg.portal = {
            enable = true;
            extraPortals = with pkgs; [
              xdg-desktop-portal-gtk
            ];
            xdgOpenUsePortal = true;
            configPackages = [ config.wayland.windowManager.hyprland.package ];
            config.hyprland = {
              default = [
                "hyprland"
                "gtk"
              ];
              "org.freedesktop.impl.portal.OpenURI" = "gtk";
              "org.freedesktop.impl.portal.FileChooser" = "gtk";
              "org.freedesktop.impl.portal.Print" = "gtk";
            };
          };

          home.packages = with pkgs; [
            hyprpicker
            wf-recorder
            grimblast
            slurp
            swappy
            xdotool
            yad
            quickshell
            playerctl
            hyprshot
            # socat # for and autowaybar.sh
            # jq # for and autowaybar.sh
          ];

          #xdg.configFile."hypr/icons" = {
          #  source = ./icons;
          #  recursive = true;
          #};

          #test later systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
          wayland.windowManager.hyprland = {
            enable = true;
            plugins = [
              # inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprwinwrap
              # inputs.hyprsysteminfo.packages.${pkgs.stdenv.hostPlatform.system}.default
            ];
            systemd = {
              enable = true;
              variables = [ "--all" ];
            };
            settings = {
              debug.disable_logs = false;
              "$ver" = "/nix/store/djzaypyb6zg501k7d77wikz7zhadsvy6-noctalia-shell-2026-04-27_6773c47/share/noctalia-shell/";
              "$mainMod" = "SUPER";
              "$term" = "${getExe pkgs.${terminal}}";
              "$editor" = "code --disable-gpu";
              "$fileManager" = "$term --class \"tuiFileManager\" -e ${tuiFileManager}";
              "$browser" = browser;
              "$ipc" = "qs -c $ver ipc call";
              env = [
                "GAMEMODE_CONFIG,/etc/gamemode.ini" # WARN: unsure if this even works.
                "XDG_CURRENT_DESKTOP,Hyprland"
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "GDK_BACKEND,wayland,x11,*"
                "NIXOS_OZONE_WL,1"
                "ELECTRON_OZONE_PLATFORM_HINT,wayland"
                "MOZ_ENABLE_WAYLAND,1"
                "OZONE_PLATFORM,wayland"
                "EGL_PLATFORM,wayland"
                "CLUTTER_BACKEND,wayland"
                "SDL_VIDEODRIVER,wayland"
                "QT_QPA_PLATFORM,wayland;xcb"
                "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
                "QT_QPA_PLATFORMTHEME,qt6ct"
                "QT_AUTO_SCREEN_SCALE_FACTOR,1"
                "QT_ENABLE_HIGHDPI_SCALING,1"
                "WLR_RENDERER_ALLOW_SOFTWARE,1"
                "NIXPKGS_ALLOW_UNFREE,1"
              ];
              exec-once = [
                #"[workspace 1 silent] ${terminal}"
                #"[workspace 5 silent] ${browser}"
                #"[workspace 6 silent] spotify"
                #"[workspace special silent] ${browser} --private-window"
                #"[workspace special silent] ${terminal}"
                "systemctl --user start hyprpolkitagent"
                "noctalia-shell"
              ];
              input = {
                #  kb_layout = "${kbdLayout}";
                #  kb_variant = "${kbdVariant}";
                repeat_delay = 275; # or 212
                repeat_rate = 35;
                numlock_by_default = true;

                follow_mouse = 1;

                touchpad.natural_scroll = false;

                tablet.output = "current";

                sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
                force_no_accel = false;
              };
              general = {
                gaps_in = 4;
                gaps_out = 9;
                border_size = 2;
                "col.active_border" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.inactive_border" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                resize_on_border = true;
                layout = "dwindle"; # dwindle or master
                # allow_tearing = true; # Allow tearing for games (use immediate window rules for specific games or all titles)
              };
              decoration = {
                shadow.enabled = false;
                rounding = 10;
                dim_special = 0.3;
                blur = {
                  enabled = true;
                  special = true;
                  size = 6; # 6
                  passes = 2; # 3
                  new_optimizations = true;
                  ignore_opacity = true;
                  xray = false;
                };
              };
              group = {
                "col.border_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
                "col.border_locked_active" = "rgba(ca9ee6ff) rgba(f2d5cfff) 45deg";
                "col.border_locked_inactive" = "rgba(b4befecc) rgba(6c7086cc) 45deg";
              };
              layerrule = [
                "blur on, match:class rofi"
                "ignore_alpha 0, match:class rofi"
                "ignore_alpha 0.7, match:class rofi"
                "blur on, match:class swaync-control-center"
                "blur on, match:class swaync-notification-window"
                "ignore_alpha 0, match:class swaync-control-center"
                "ignore_alpha 0, match:class swaync-notification-window"
                "ignore_alpha 0.7, match:class swaync-control-center"
                # "ignorealpha 0.8, swaync-notification-window"
                # "dimaround, swaync-control-center"
              ];
              animations = {
                enabled = true;
                bezier = [
                  "linear, 0, 0, 1, 1"
                  "md3_standard, 0.2, 0, 0, 1"
                  "md3_decel, 0.05, 0.7, 0.1, 1"
                  "md3_accel, 0.3, 0, 0.8, 0.15"
                  "overshot, 0.05, 0.9, 0.1, 1.1"
                  "crazyshot, 0.1, 1.5, 0.76, 0.92"
                  "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
                  "fluent_decel, 0.1, 1, 0, 1"
                  "easeInOutCirc, 0.85, 0, 0.15, 1"
                  "easeOutCirc, 0, 0.55, 0.45, 1"
                  "easeOutExpo, 0.16, 1, 0.3, 1"
                ];
                animation = [
                  "windows, 1, 3, md3_decel, popin 60%"
                  "border, 1, 10, default"
                  "fade, 1, 2.5, md3_decel"
                  # "workspaces, 1, 3.5, md3_decel, slide"
                  "workspaces, 1, 3.5, easeOutExpo, slide"
                  # "workspaces, 1, 7, fluent_decel, slidefade 15%"
                  # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
                  "specialWorkspace, 1, 3, md3_decel, slidevert"
                ];
              };
              render = {
                direct_scanout = 0; # 0 = off, 1 = on, 2 = auto (on with content type ‘game’)
              };
              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
              };
              misc = {
                disable_hyprland_logo = true;
                mouse_move_focuses_monitor = true;
                swallow_regex = "^(Alacritty|kitty)$";
                enable_swallow = true;
                vfr = true; # always keep on
                vrr = 1; # enable variable refresh rate (0=off, 1=on, 2=fullscreen only, 3 = fullscreen games/media)
              };
              xwayland.force_zero_scaling = false;
              gesture = [
                "3, horizontal, workspace"
                "3, right, mod: $mainMod, dispatcher, movetoworkspace, r+1"
                "3, left, mod: $mainMod, dispatcher, movetoworkspace, r-1"
              ];
              dwindle = {
                pseudotile = true;
                preserve_split = true;
              };
              master = {
                new_status = "master";
                new_on_top = true;
                mfact = 0.5;
              };
              windowrule = [
                # "noanim, match:class ^(Rofi)$
                # "tile,match:title (.*)(Godot)(.*)$"
                # "workspace 1, match:class ^(kitty|Alacritty|org.wezfurlong.wezterm)$"
                # "workspace 2, match:class ^(code|VSCodium|code-url-handler|codium-url-handler)$"
                # "workspace 3, match:class ^(krita)$"
                # "workspace 3, match:title (.*)(Godot)(.*)$"
                # "workspace 3, match:title (GNU Image Manipulation Program)(.*)$"
                # "workspace 3, match:class ^(factorio)$"
                # "workspace 3, match:class ^(steam)$"
                # "workspace 5, match:class ^(firefox|floorp|zen|zen-beta)$"
                # "workspace 6, match:class ^(Spotify)$"
                # "workspace 6, match:title (.*)(Spotify)(.*)$"

                # Can use FLOAT FLOAT for active and inactive or just FLOAT
                "opacity 1.00 1.00,match:class ^(firefox|Brave-browser|floorp|zen|zen-beta)$"
                "opacity 0.90 0.80,match:class ^(Emacs)$"
                "opacity 0.90 0.80,match:class ^(gcr-prompter)$" # keyring prompt
                "opacity 0.90 0.80,match:title ^(Hyprland Polkit Agent)$" # polkit prompt
                "opacity 0.90 0.80,match:class ^(obsidian)$"
                "opacity 0.90 0.80,match:class ^(Lutris|lutris|net.lutris.Lutris)$"
                "opacity 0.80 0.70,match:class ^(kitty|alacritty|Alacritty|org.wezfurlong.wezterm)$"
                "opacity 0.80 0.70,match:class ^(nvim-wrapper)$"
                "opacity 0.80 0.70,match:class ^(gnome-disks)$"
                "opacity 0.80 0.70,match:class ^(org.gnome.Nautilus|Thunar|thunar|pcmanfm)$"
                "opacity 0.80 0.70,match:class ^(thunar-volman-settings)$"
                "opacity 0.80 0.70,match:class ^(org.gnome.FileRoller)$"
                "opacity 0.80 0.70,match:class ^(io.github.ilya_zlobintsev.LACT)$"
                "opacity 0.80 0.70,match:class ^(Steam|steam|steamwebhelper)$"
                # spotify
                "opacity 0.80 0.70,match:class ^(Spotify|spotify)$"
                "opacity 0.80 0.70,match:title (.*)(Spotify)(.*)$"

                # youtube music
                "opacity 0.90 0.80,match:class (.*)(youtube_music)(.*)$"

                "opacity 0.80 0.70,match:title ^(Kvantum Manager)$"
                "opacity 0.80 0.70,match:class ^(VSCodium|codium-url-handler)$"
                "opacity 0.80 0.70,match:class ^(code|code-url-handler)$"
                "opacity 0.80 0.70,match:class ^(tuiFileManager)$"
                "opacity 0.80 0.70,match:class ^(org.kde.dolphin)$"
                "opacity 0.80 0.70,match:class ^(org.kde.ark)$"
                "opacity 0.80 0.70,match:class ^(nwg-look)$"
                "opacity 0.80 0.70,match:class ^(qt5ct|qt6ct)$"
                "opacity 0.80 0.70,match:class ^(yad)$"

                "opacity 0.90 0.80,match:class ^(discord)$" # Discord-Electron
                "opacity 0.90 0.80,match:class ^(WebCord)$" # WebCord-Electron
                "opacity 0.90 0.80,match:class ^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "opacity 0.80 0.70,match:class ^(com.github.tchx84.Flatseal)$" # Flatseal-Gtk
                "opacity 0.80 0.70,match:class ^(hu.kramo.Cartridges)$" # Cartridges-Gtk
                "opacity 0.80 0.70,match:class ^(com.obsproject.Studio)$" # Obs-Qt
                "opacity 0.80 0.70,match:class ^(gnome-boxes)$" # Boxes-Gtk
                "opacity 0.80 0.70,match:class ^(app.drey.Warp)$" # Warp-Gtk
                "opacity 0.80 0.70,match:class ^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "opacity 0.80 0.70,match:class ^(Signal)$" # Signal-Gtk
                "opacity 0.80 0.70,match:class ^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk

                "opacity 0.80 0.70,match:class ^(pavucontrol)$"
                "opacity 0.80 0.70,match:class ^(org.pulseaudio.pavucontrol)$"
                "opacity 0.80 0.70,match:class ^(blueman-manager)$"
                "opacity 0.80 0.70,match:class ^(.blueman-manager-wrapped)$"
                "opacity 0.80 0.70,match:class ^(nm-applet)$"
                "opacity 0.80 0.70,match:class ^(nm-connection-editor)$"
                "opacity 0.80 0.70,match:class ^(org.kde.polkit-kde-authentication-agent-1)$"

                #Material Gram
                "opacity 0.90 0.80, match:title ^(.*)(materialgram)(.*)$, match:class ^(.*)(materialgram)(.*)$"

                #float materialgram Media/Instant View and turn off transparency
                "float on, match:title (.*)(Media viewer)(.*)$, match:class (.*)(materialgram)(.*)$"
                "float on, match:title (.*)(Instant View)(.*)$, match:class (.*)(materialgram)(.*)$"

                "opacity 1.00 0.90, match:title (.*)(Media viewer)(.*)$, match:class (.*)(materialgram)(.*)$"
                "opacity 1.00 0.90, match:title (.*)(Instant View)(.*)$, match:class (.*)(materialgram)(.*)$"

                # Block discord and browsers from screenshare/screenshots
                # "noscreenshare,match:class ^(firefox|Brave-browser|floorp|zen|zen-beta)$"
                # "noscreenshare,match:class ^(discord)$"

                # Float and pin Picture-in-Picture in browsers
                "float on, match:title ^(Picture-in-Picture)$,match:class ^(zen|zen-beta|floorp|firefox)$"
                "pin on, match:title ^(Picture-in-Picture)$,match:class ^(zen|zen-beta|floorp|firefox)$"

                #TODO:: steam friends list float
                #"float,match:class ^(steam)"
                # zen browser extension windows float
                "float on, match:title (.*)(Extension)(.*)$, match:class ^(zen)$"

                "content game, match:tag games"
                "tag +games, match:content game"
                "tag +games, match:class ^(steam_app.*|steam_app_\d+)$"
                "tag +games, match:class ^(gamescope)$"
                "tag +games, match:class (Waydroid)"
                "tag +games, match:class (osu!)"

                # Games
                # Games
                "sync_fullscreen on, match:tag games"
                "fullscreen on, match:tag games"
                "border_size 0, match:tag games"
                "no_shadow on, match:tag games"
                "no_blur on, match:tag games"
                "no_anim on, match:tag games"

                "float on,match:class ^(qt5ct)$"
                "float on,match:class ^(nwg-look)$"
                "float on,match:class ^(org.kde.ark)$"
                "float on,match:class ^(Signal)$" # Signal-Gtk
                "float on,match:class ^(com.github.rafostar.Clapper)$" # Clapper-Gtk
                "float on,match:class ^(app.drey.Warp)$" # Warp-Gtk
                "float on,match:class ^(net.davidotek.pupgui2)$" # ProtonUp-Qt
                "float on,match:class ^(eog)$" # Imageviewer-Gtk
                "float on,match:class ^(io.gitlab.theevilskeleton.Upscaler)$" # Upscaler-Gtk
                "float on,match:class ^(yad)$"
                "float on,match:class ^(pavucontrol)$"
                "float on,match:class ^(blueman-manager)$"
                "float on,match:class ^(.blueman-manager-wrapped)$"
                "float on,match:class ^(nm-applet)$"
                "float on,match:class ^(nm-connection-editor)$"
                "float on,match:class ^(org.kde.polkit-kde-authentication-agent-1)$"
              ];
              binde = [
                # Resize windows
                "$mainMod SHIFT, right, resizeactive, 30 0"
                "$mainMod SHIFT, left, resizeactive, -30 0"
                "$mainMod SHIFT, up, resizeactive, 0 -30"
                "$mainMod SHIFT, down, resizeactive, 0 30"

                # Resize windows with hjkl keys
                "$mainMod SHIFT, l, resizeactive, 30 0"
                "$mainMod SHIFT, h, resizeactive, -30 0"
                "$mainMod SHIFT, k, resizeactive, 0 -30"
                "$mainMod SHIFT, j, resizeactive, 0 30"

                # Functional keybinds
                ",XF86MonBrightnessDown,exec, $ipc brightness decrease"
                ",XF86MonBrightnessUp,exec, $ipc brightness increase"
                ",XF86AudioLowerVolume,exec, $ipc volume decrease"
                ",XF86AudioRaiseVolume,exec, $ipc volume increase"
              ];
              bind = [
                "$mainMod, SPACE, exec, $ipc launcher toggle"
                "$mainMod, S, exec, $ipc controlCenter toggle"
                "$mainMod, comma, exec, $ipc settings toggle"

                # "$mainMod, F8, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 40"
                # "$mainMod ALT, mouse:276, exec, kill $(cat /tmp/auto-clicker.pid) 2>/dev/null || ${lib.getExe autoclicker} --cps 60"

                # Night Mode (lower value means warmer temp)
                #                 "$mainMod, F9, exec, ${getExe pkgs.hyprsunset} --temperature 3500" # good values: 3500, 3000, 2500
                #                 "$mainMod, F10, exec, pkill hyprsunset"

                # Window/Session actions
                "$mainMod, Q, exec, ${./submodules/scripts/dontkillsteam.sh}" # killactive, kill the window on focus
                "ALT, F4, exec, ${./submodules/scripts/dontkillsteam.sh}" # killactive, kill the window on focus
                "$mainMod, delete, exit" # kill hyperland session
                "$mainMod, W, togglefloating" # toggle the window on focus to float
                "$mainMod SHIFT, G, togglegroup" # toggle the window on focus to float
                "ALT, return, fullscreen" # toggle the window on focus to fullscreen
                "$mainMod ALT, L, exec, hyprlock" # lock screen
                "$mainMod, backspace, exec, pkill -x wlogout || wlogout -b 4" # logout menu
                "$CONTROL, ESCAPE, exec, pkill waybar || waybar" # toggle waybar

                # Applications/Programs
                "$mainMod, Return, exec, $term"
                "$mainMod, E, exec, $fileManager"
                "$mainMod, C, exec, $editor"
                "$mainMod, F, exec, $browser"
                "$mainMod SHIFT, Y, exec, youtube-music"
                "$CONTROL ALT, DELETE, exec, $term -e '${getExe pkgs.btop}'" # System Monitor
                "$mainMod CTRL, C, exec, hyprpicker --autocopy --format=hex" # Colour Picker
                #                 "$mainMod ALT, G, exec, ${./scripts/gamemode.sh}" # disable hypr effects for gamemode
                #                 "$mainMod, V, exec, ${./scripts/ClipManager.sh}" # Clipboard Manager
                #                 "$mainMod, M, exec, ${./scripts/rofimusic.sh}" # online music

                #                 # Screenshot/Screencapture
                #                 "$mainMod SHIFT, R, exec, ${./scripts/screen-record.sh} a" # Screen Record (area select)
                #                 "$mainMod CTRL, R, exec, ${./scripts/screen-record.sh} m" # Screen Record (monitor select)
                # -- screenshots
                # Region
                "$mainMod, P, exec, hyprshot -m region" #Screenshot a region
                ", PRINT, exec, hyprshot -m region" #screenshot region
                #Output
                "$mainMod SHIFT, P, exec, hyprshot -m output" #Display output
                ", SHIFT PRINT, exec, hyprshot -m output"


                # Functional keybinds
                ",xf86Sleep, exec, systemctl suspend" # Put computer into sleep mode
                ",XF86AudioMicMute,exec,pamixer --default-source -t" # mute mic
                ",XF86AudioMute,exec, $ipc volume muteOutput" # mute audio
                ",XF86AudioPlay,exec,playerctl play-pause" # Play/Pause media
                ",XF86AudioPause,exec,playerctl play-pause" # Play/Pause media
                ",xf86AudioNext,exec,playerctl next" # go to next media
                ",xf86AudioPrev,exec,playerctl previous" # go to previous media

                # ",xf86AudioNext,exec,${./scripts/MediaCtrl.sh} next" # go to next media
                # ",xf86AudioPrev,exec,${./scripts/MediaCtrl.sh} previous" # go to previous media
                # ",XF86AudioPlay,exec,${./scripts/MediaCtrl.sh} play-pause" # go to next media
                # ",XF86AudioPause,exec,${./scripts/MediaCtrl.sh} play-pause" # go to next media

                # to switch between windows in a floating workspace
                "$mainMod, Tab, cyclenext"
                "$mainMod, Tab, bringactivetotop"

                # Switch workspaces relative to the active workspace with mainMod + CTRL + [←→]
                "$mainMod CTRL, right, workspace, r+1"
                "$mainMod CTRL, left, workspace, r-1"

                # move to the first empty workspace instantly with mainMod + CTRL + [↓]
                "$mainMod CTRL, down, workspace, empty"

                # Move focus with mainMod + arrow keys
                "$mainMod, left, movefocus, l"
                "$mainMod, right, movefocus, r"
                "$mainMod, up, movefocus, u"
                "$mainMod, down, movefocus, d"
                "ALT, Tab, movefocus, d"

                # Move focus with mainMod + HJKL keys
                "$mainMod, h, movefocus, l"
                "$mainMod, l, movefocus, r"
                "$mainMod, k, movefocus, u"
                "$mainMod, j, movefocus, d"

                # Go to workspace 6 and 7 with mouse side buttons
                "$mainMod, mouse:276, workspace, 5"
                "$mainMod, mouse:275, workspace, 6"
                "$mainMod SHIFT, mouse:276, movetoworkspace, 5"
                "$mainMod SHIFT, mouse:275, movetoworkspace, 6"
                "$mainMod CTRL, mouse:276, movetoworkspacesilent, 5"
                "$mainMod CTRL, mouse:275, movetoworkspacesilent, 6"

                # Rebuild NixOS with a KeyBind
                "$mainMod, U, exec, $term -e rebuild"

                # Scroll through existing workspaces with mainMod + scroll
                "$mainMod, mouse_down, workspace, e+1"
                "$mainMod, mouse_up, workspace, e-1"

                # Move active window to a relative workspace with mainMod + CTRL + ALT + [←→]
                "$mainMod CTRL ALT, right, movetoworkspace, r+1"
                "$mainMod CTRL ALT, left, movetoworkspace, r-1"

                # Move active window around current workspace with mainMod + SHIFT + CTRL [←→↑↓]
                "$mainMod SHIFT $CONTROL, left, movewindow, l"
                "$mainMod SHIFT $CONTROL, right, movewindow, r"
                "$mainMod SHIFT $CONTROL, up, movewindow, u"
                "$mainMod SHIFT $CONTROL, down, movewindow, d"

                # Move active window around current workspace with mainMod + SHIFT + CTRL [HLJK]
                "$mainMod SHIFT $CONTROL, H, movewindow, l"
                "$mainMod SHIFT $CONTROL, L, movewindow, r"
                "$mainMod SHIFT $CONTROL, K, movewindow, u"
                "$mainMod SHIFT $CONTROL, J, movewindow, d"

                # Special workspaces (scratchpad)
                "$mainMod CTRL, S, movetoworkspacesilent, special"
                "$mainMod ALT, S, movetoworkspacesilent, special"
                "$mainMod, S, togglespecialworkspace,"
              ]
              ++ (builtins.concatLists (
                builtins.genList (
                  x:
                  let
                    ws =
                      let
                        c = (x + 1) / 10;
                      in
                      builtins.toString (x + 1 - (c * 10));
                  in
                  [
                    "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
                    "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                    "$mainMod CTRL, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
                  ]
                ) 10
              ));
              bindm = [
                # Move/Resize windows with mainMod + LMB/RMB and dragging
                "$mainMod, mouse:272, movewindow"
                "$mainMod, mouse:273, resizewindow"
              ];

              binds = {
                workspace_back_and_forth = 0;
                #allow_workspace_cycles=1
                #pass_mouse_when_bound=0
              };

              monitor = [
                # Easily plug in any monitor
                ",preferred,auto,1.5"

                # My Monitors (Fine to leave these since i used the serial numbers)
              ];

              workspace = [
                # Binds workspaces to my monitors (find desc with: hyprctl monitors)
                #  "1,monitor:desc:BNQ BenQ EL2870U PCK00489SL0,default:true"
                #  "2,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
                #  "3,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
                #  "4,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
                #  "5,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0,default:true"
                #  "6,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0"
                #  "7,monitor:desc:BNQ BenQ EW277HDR 99J01861SL0"
                #  "8,monitor:desc:BNQ BenQ xl2420t 99D06760SL0,default:true"
                #  "9,monitor:desc:BNQ BenQ xl2420t 99D06760SL0"
                #  "10,monitor:desc:BNQ BenQ EL2870U PCK00489SL0"
              ];
            };
          };
        }
      )
    ];
}
