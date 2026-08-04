{ self, inputs, ... }:
{
  flake.nixosModules.hyprland =
    { pkgs, lib, ... }:
    let
      system = pkgs.stdenv.hostPlatform.system;

      noctaliaExe = lib.getExe self.packages.${system}.myNoctalia;
      kittyExe    = lib.getExe self.packages.${system}.myKitty;
      zenExe      = lib.getExe inputs.zen-browser.packages.${system}.default;

      dontkillsteam = pkgs.writeShellScript "dontkillsteam" ''
        if [[ $(hyprctl activewindow -j | ${lib.getExe pkgs.jq} -r ".class") == "Steam" ]]; then
          ${pkgs.xdotool}/bin/xdotool windowunmap $(${pkgs.xdotool}/bin/xdotool getactivewindow)
        else
          hyprctl dispatch killactive ""
        fi
      '';

      hyprlandConf = pkgs.writeText "hyprland.conf" ''
        $mainMod    = SUPER
        $term       = ${kittyExe}
        $editor     = code --disable-gpu
        $fileManager= ${kittyExe} --class "tuiFileManager" -e yazi
        $browser    = ${zenExe}
        $ipc        = ${noctaliaExe} ipc call

        exec-once = systemctl --user start hyprpolkitagent
        exec-once = ${noctaliaExe}

        env = XDG_CURRENT_DESKTOP,Hyprland
        env = XDG_SESSION_DESKTOP,Hyprland
        env = XDG_SESSION_TYPE,wayland
        env = GDK_BACKEND,wayland,x11,*
        env = NIXOS_OZONE_WL,1
        env = ELECTRON_OZONE_PLATFORM_HINT,wayland
        env = MOZ_ENABLE_WAYLAND,1
        env = OZONE_PLATFORM,wayland
        env = EGL_PLATFORM,wayland
        env = CLUTTER_BACKEND,wayland
        env = SDL_VIDEODRIVER,wayland
        env = QT_QPA_PLATFORM,wayland;xcb
        env = QT_WAYLAND_DISABLE_WINDOWDECORATION,1
        env = QT_QPA_PLATFORMTHEME,qt6ct
        env = QT_AUTO_SCREEN_SCALE_FACTOR,1
        env = QT_ENABLE_HIGHDPI_SCALING,1
        env = WLR_RENDERER_ALLOW_SOFTWARE,1
        env = NIXPKGS_ALLOW_UNFREE,1

        monitor = ,preferred,auto,1.5

        input {
          kb_layout         = us,ua
          repeat_delay      = 275
          repeat_rate       = 35
          numlock_by_default = true
          follow_mouse      = 1
          sensitivity       = 0
          force_no_accel    = false
          touchpad {
            natural_scroll = false
          }
          tablet {
            output = current
          }
        }

        general {
          gaps_in             = 4
          gaps_out            = 9
          border_size         = 2
          col.active_border   = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
          col.inactive_border = rgba(b4befecc) rgba(6c7086cc) 45deg
          resize_on_border    = true
          layout              = dwindle
        }

        decoration {
          rounding    = 10
          dim_special = 0.3
          shadow {
            enabled = false
          }
          blur {
            enabled          = true
            special          = true
            size             = 6
            passes           = 2
            new_optimizations = true
            ignore_opacity   = true
            xray             = false
          }
        }

        group {
          col.border_active          = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
          col.border_inactive        = rgba(b4befecc) rgba(6c7086cc) 45deg
          col.border_locked_active   = rgba(ca9ee6ff) rgba(f2d5cfff) 45deg
          col.border_locked_inactive = rgba(b4befecc) rgba(6c7086cc) 45deg
        }

        layerrule = blur on,           match:class rofi
        layerrule = ignore_alpha 0.7,  match:class rofi
        layerrule = blur on,           match:class swaync-control-center
        layerrule = blur on,           match:class swaync-notification-window
        layerrule = ignore_alpha 0.7,  match:class swaync-control-center

        animations {
          enabled = true
          bezier = linear,        0,    0,    1,    1
          bezier = md3_standard,  0.2,  0,    0,    1
          bezier = md3_decel,     0.05, 0.7,  0.1,  1
          bezier = md3_accel,     0.3,  0,    0.8,  0.15
          bezier = overshot,      0.05, 0.9,  0.1,  1.1
          bezier = crazyshot,     0.1,  1.5,  0.76, 0.92
          bezier = hyprnostretch, 0.05, 0.9,  0.1,  1.0
          bezier = fluent_decel,  0.1,  1,    0,    1
          bezier = easeInOutCirc, 0.85, 0,    0.15, 1
          bezier = easeOutCirc,   0,    0.55, 0.45, 1
          bezier = easeOutExpo,   0.16, 1,    0.3,  1
          animation = windows,          1, 3,   md3_decel, popin 60%
          animation = border,           1, 10,  default
          animation = fade,             1, 2.5, md3_decel
          animation = workspaces,       1, 3.5, easeOutExpo, slide
          animation = specialWorkspace, 1, 3,   md3_decel,   slidevert
        }

        render {
          direct_scanout = 0
        }

        misc {
          disable_hyprland_logo    = true
          mouse_move_focuses_monitor = true
          swallow_regex            = ^(Alacritty|kitty)$
          enable_swallow           = true
          vfr                      = true
          vrr                      = 1
        }

        ecosystem {
          no_update_news  = true
          no_donation_nag = true
        }

        xwayland {
          force_zero_scaling = false
        }

        dwindle {
          pseudotile    = true
          preserve_split = true
        }

        master {
          new_status = master
          new_on_top = true
          mfact      = 0.5
        }

        binds {
          workspace_back_and_forth = 0
        }

        gesture = 3, horizontal, workspace
        gesture = 3, right, mod: $mainMod, dispatcher, movetoworkspace, r+1
        gesture = 3, left,  mod: $mainMod, dispatcher, movetoworkspace, r-1

        # ── Opacity ────────────────────────────────────────────────────────
        windowrule = opacity 1.00 1.00, match:class ^(firefox|Brave-browser|floorp|zen|zen-beta)$
        windowrule = opacity 0.90 0.80, match:class ^(Emacs)$
        windowrule = opacity 0.90 0.80, match:class ^(gcr-prompter)$
        windowrule = opacity 0.90 0.80, match:title ^(Hyprland Polkit Agent)$
        windowrule = opacity 0.90 0.80, match:class ^(obsidian)$
        windowrule = opacity 0.90 0.80, match:class ^(Lutris|lutris|net.lutris.Lutris)$
        windowrule = opacity 0.80 0.70, match:class ^(kitty|alacritty|Alacritty|org.wezfurlong.wezterm)$
        windowrule = opacity 0.80 0.70, match:class ^(nvim-wrapper)$
        windowrule = opacity 0.80 0.70, match:class ^(gnome-disks)$
        windowrule = opacity 0.80 0.70, match:class ^(org.gnome.Nautilus|Thunar|thunar|pcmanfm)$
        windowrule = opacity 0.80 0.70, match:class ^(thunar-volman-settings)$
        windowrule = opacity 0.80 0.70, match:class ^(org.gnome.FileRoller)$
        windowrule = opacity 0.80 0.70, match:class ^(io.github.ilya_zlobintsev.LACT)$
        windowrule = opacity 0.80 0.70, match:class ^(Steam|steam|steamwebhelper)$
        windowrule = opacity 0.80 0.70, match:class ^(Spotify|spotify)$
        windowrule = opacity 0.80 0.70, match:title (.*)(Spotify)(.*)$
        windowrule = opacity 0.90 0.80, match:class (.*)(youtube_music)(.*)$
        windowrule = opacity 0.80 0.70, match:title ^(Kvantum Manager)$
        windowrule = opacity 0.80 0.70, match:class ^(VSCodium|codium-url-handler)$
        windowrule = opacity 0.80 0.70, match:class ^(code|code-url-handler)$
        windowrule = opacity 0.80 0.70, match:class ^(tuiFileManager)$
        windowrule = opacity 0.80 0.70, match:class ^(org.kde.dolphin)$
        windowrule = opacity 0.80 0.70, match:class ^(org.kde.ark)$
        windowrule = opacity 0.80 0.70, match:class ^(nwg-look)$
        windowrule = opacity 0.80 0.70, match:class ^(qt5ct|qt6ct)$
        windowrule = opacity 0.80 0.70, match:class ^(yad)$
        windowrule = opacity 0.90 0.80, match:class ^(discord)$
        windowrule = opacity 0.90 0.80, match:class ^(WebCord)$
        windowrule = opacity 0.90 0.80, match:class ^(com.github.rafostar.Clapper)$
        windowrule = opacity 0.80 0.70, match:class ^(com.github.tchx84.Flatseal)$
        windowrule = opacity 0.80 0.70, match:class ^(hu.kramo.Cartridges)$
        windowrule = opacity 0.80 0.70, match:class ^(com.obsproject.Studio)$
        windowrule = opacity 0.80 0.70, match:class ^(gnome-boxes)$
        windowrule = opacity 0.80 0.70, match:class ^(app.drey.Warp)$
        windowrule = opacity 0.80 0.70, match:class ^(net.davidotek.pupgui2)$
        windowrule = opacity 0.80 0.70, match:class ^(Signal)$
        windowrule = opacity 0.80 0.70, match:class ^(io.gitlab.theevilskeleton.Upscaler)$
        windowrule = opacity 0.80 0.70, match:class ^(pavucontrol)$
        windowrule = opacity 0.80 0.70, match:class ^(org.pulseaudio.pavucontrol)$
        windowrule = opacity 0.80 0.70, match:class ^(.blueman-manager-wrapped|blueman-manager)$
        windowrule = opacity 0.80 0.70, match:class ^(nm-applet|nm-connection-editor)$
        windowrule = opacity 0.80 0.70, match:class ^(org.kde.polkit-kde-authentication-agent-1)$
        windowrule = opacity 0.90 0.80, match:title ^(.*)(materialgram)(.*)$, match:class ^(.*)(materialgram)(.*)$

        # ── Games ──────────────────────────────────────────────────────────
        windowrule = content game,       match:tag games
        windowrule = tag +games,         match:content game
        windowrule = tag +games,         match:class ^(steam_app.*|steam_app_\d+)$
        windowrule = tag +games,         match:class ^(gamescope)$
        windowrule = tag +games,         match:class (Waydroid)
        windowrule = tag +games,         match:class (osu!)
        windowrule = sync_fullscreen on, match:tag games
        windowrule = fullscreen on,      match:tag games
        windowrule = border_size 0,      match:tag games
        windowrule = no_shadow on,       match:tag games
        windowrule = no_blur on,         match:tag games
        windowrule = no_anim on,         match:tag games

        # ── Float ──────────────────────────────────────────────────────────
        windowrule = float on, match:title ^(Picture-in-Picture)$, match:class ^(zen|zen-beta|floorp|firefox)$
        windowrule = pin on,   match:title ^(Picture-in-Picture)$, match:class ^(zen|zen-beta|floorp|firefox)$
        windowrule = float on, match:title (.*)(Media viewer)(.*)$, match:class (.*)(materialgram)(.*)$
        windowrule = float on, match:title (.*)(Instant View)(.*)$, match:class (.*)(materialgram)(.*)$
        windowrule = opacity 1.00 0.90, match:title (.*)(Media viewer)(.*)$, match:class (.*)(materialgram)(.*)$
        windowrule = opacity 1.00 0.90, match:title (.*)(Instant View)(.*)$, match:class (.*)(materialgram)(.*)$
        windowrule = float on, match:title (.*)(Extension)(.*)$, match:class ^(zen)$
        windowrule = float on, match:class ^(qt5ct)$
        windowrule = float on, match:class ^(nwg-look)$
        windowrule = float on, match:class ^(org.kde.ark)$
        windowrule = float on, match:class ^(Signal)$
        windowrule = float on, match:class ^(com.github.rafostar.Clapper)$
        windowrule = float on, match:class ^(app.drey.Warp)$
        windowrule = float on, match:class ^(net.davidotek.pupgui2)$
        windowrule = float on, match:class ^(eog)$
        windowrule = float on, match:class ^(io.gitlab.theevilskeleton.Upscaler)$
        windowrule = float on, match:class ^(yad)$
        windowrule = float on, match:class ^(pavucontrol)$
        windowrule = float on, match:class ^(.blueman-manager-wrapped|blueman-manager)$
        windowrule = float on, match:class ^(nm-applet|nm-connection-editor)$
        windowrule = float on, match:class ^(org.kde.polkit-kde-authentication-agent-1)$

        # ── Keybindings ────────────────────────────────────────────────────
        bind = $mainMod,       SPACE,    exec, $ipc launcher toggle
        bind = $mainMod,       S,        exec, $ipc controlCenter toggle
        bind = $mainMod,       comma,    exec, $ipc settings toggle

        bind = $mainMod,       Q,        exec, ${dontkillsteam}
        bind = ALT,            F4,       exec, ${dontkillsteam}
        bind = $mainMod,       delete,   exit
        bind = $mainMod,       W,        togglefloating
        bind = $mainMod SHIFT, G,        togglegroup
        bind = ALT,            return,   fullscreen
        bind = $mainMod ALT,   L,        exec, hyprlock
        bind = $mainMod,       backspace, exec, pkill -x wlogout || wlogout -b 4

        bind = $mainMod,       Return,   exec, $term
        bind = $mainMod,       E,        exec, $fileManager
        bind = $mainMod,       C,        exec, $editor
        bind = $mainMod,       F,        exec, $browser

        bind = $mainMod,       P,        exec, hyprshot -m region
        bind = ,               PRINT,    exec, hyprshot -m region
        bind = $mainMod SHIFT, P,        exec, hyprshot -m output
        bind = , SHIFT PRINT,            exec, hyprshot -m output

        bind = ,  xf86Sleep,          exec, systemctl suspend
        bind = ,  XF86AudioMicMute,   exec, pamixer --default-source -t
        bind = ,  XF86AudioMute,      exec, $ipc volume muteOutput
        bind = ,  XF86AudioPlay,      exec, playerctl play-pause
        bind = ,  XF86AudioPause,     exec, playerctl play-pause
        bind = ,  xf86AudioNext,      exec, playerctl next
        bind = ,  xf86AudioPrev,      exec, playerctl previous

        bind = $mainMod, Tab,         cyclenext
        bind = $mainMod, Tab,         bringactivetotop

        bind = $mainMod CTRL, right,  workspace, r+1
        bind = $mainMod CTRL, left,   workspace, r-1
        bind = $mainMod CTRL, down,   workspace, empty

        bind = $mainMod, left,        movefocus, l
        bind = $mainMod, right,       movefocus, r
        bind = $mainMod, up,          movefocus, u
        bind = $mainMod, down,        movefocus, d
        bind = ALT,      Tab,         movefocus, d
        bind = $mainMod, h,           movefocus, l
        bind = $mainMod, l,           movefocus, r
        bind = $mainMod, k,           movefocus, u
        bind = $mainMod, j,           movefocus, d

        bind = $mainMod,       mouse:276, workspace, 5
        bind = $mainMod,       mouse:275, workspace, 6
        bind = $mainMod SHIFT, mouse:276, movetoworkspace, 5
        bind = $mainMod SHIFT, mouse:275, movetoworkspace, 6
        bind = $mainMod CTRL,  mouse:276, movetoworkspacesilent, 5
        bind = $mainMod CTRL,  mouse:275, movetoworkspacesilent, 6

        bind = $mainMod, mouse_down,  workspace, e+1
        bind = $mainMod, mouse_up,    workspace, e-1

        bind = $mainMod CTRL ALT, right, movetoworkspace, r+1
        bind = $mainMod CTRL ALT, left,  movetoworkspace, r-1

        bind = $mainMod SHIFT CTRL, left,  movewindow, l
        bind = $mainMod SHIFT CTRL, right, movewindow, r
        bind = $mainMod SHIFT CTRL, up,    movewindow, u
        bind = $mainMod SHIFT CTRL, down,  movewindow, d
        bind = $mainMod SHIFT CTRL, H,     movewindow, l
        bind = $mainMod SHIFT CTRL, L,     movewindow, r
        bind = $mainMod SHIFT CTRL, K,     movewindow, u
        bind = $mainMod SHIFT CTRL, J,     movewindow, d

        bind = $mainMod CTRL, S,     movetoworkspacesilent, special
        bind = $mainMod ALT,  S,     movetoworkspacesilent, special
        bind = $mainMod,      S,     togglespecialworkspace,

        bind = $mainMod,       1, workspace, 1
        bind = $mainMod,       2, workspace, 2
        bind = $mainMod,       3, workspace, 3
        bind = $mainMod,       4, workspace, 4
        bind = $mainMod,       5, workspace, 5
        bind = $mainMod,       6, workspace, 6
        bind = $mainMod,       7, workspace, 7
        bind = $mainMod,       8, workspace, 8
        bind = $mainMod,       9, workspace, 9
        bind = $mainMod,       0, workspace, 10
        bind = $mainMod SHIFT, 1, movetoworkspace, 1
        bind = $mainMod SHIFT, 2, movetoworkspace, 2
        bind = $mainMod SHIFT, 3, movetoworkspace, 3
        bind = $mainMod SHIFT, 4, movetoworkspace, 4
        bind = $mainMod SHIFT, 5, movetoworkspace, 5
        bind = $mainMod SHIFT, 6, movetoworkspace, 6
        bind = $mainMod SHIFT, 7, movetoworkspace, 7
        bind = $mainMod SHIFT, 8, movetoworkspace, 8
        bind = $mainMod SHIFT, 9, movetoworkspace, 9
        bind = $mainMod SHIFT, 0, movetoworkspace, 10
        bind = $mainMod CTRL,  1, movetoworkspacesilent, 1
        bind = $mainMod CTRL,  2, movetoworkspacesilent, 2
        bind = $mainMod CTRL,  3, movetoworkspacesilent, 3
        bind = $mainMod CTRL,  4, movetoworkspacesilent, 4
        bind = $mainMod CTRL,  5, movetoworkspacesilent, 5
        bind = $mainMod CTRL,  6, movetoworkspacesilent, 6
        bind = $mainMod CTRL,  7, movetoworkspacesilent, 7
        bind = $mainMod CTRL,  8, movetoworkspacesilent, 8
        bind = $mainMod CTRL,  9, movetoworkspacesilent, 9
        bind = $mainMod CTRL,  0, movetoworkspacesilent, 10

        binde = $mainMod SHIFT, right, resizeactive,  30 0
        binde = $mainMod SHIFT, left,  resizeactive, -30 0
        binde = $mainMod SHIFT, up,    resizeactive,   0 -30
        binde = $mainMod SHIFT, down,  resizeactive,   0 30
        binde = $mainMod SHIFT, l,     resizeactive,  30 0
        binde = $mainMod SHIFT, h,     resizeactive, -30 0
        binde = $mainMod SHIFT, k,     resizeactive,   0 -30
        binde = $mainMod SHIFT, j,     resizeactive,   0 30
        binde = , XF86MonBrightnessDown, exec, $ipc brightness decrease
        binde = , XF86MonBrightnessUp,   exec, $ipc brightness increase
        binde = , XF86AudioLowerVolume,  exec, $ipc volume decrease
        binde = , XF86AudioRaiseVolume,  exec, $ipc volume increase

        bindm = $mainMod, mouse:272, movewindow
        bindm = $mainMod, mouse:273, resizewindow
      '';
    in
    {
      services.displayManager.defaultSession = "hyprland";

      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${system}.hyprland;
        portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = true;
        config.hyprland = {
          default = [ "hyprland" "gtk" ];
          "org.freedesktop.impl.portal.OpenURI"     = "gtk";
          "org.freedesktop.impl.portal.FileChooser" = "gtk";
          "org.freedesktop.impl.portal.Print"       = "gtk";
        };
      };

      systemd.user.services.hyprpolkitagent = {
        description = "Hyprpolkitagent - Polkit authentication agent";
        wantedBy = [ "graphical-session.target" ];
        wants    = [ "graphical-session.target" ];
        after    = [ "graphical-session.target" ];
        serviceConfig = {
          Type          = "simple";
          ExecStart     = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
          Restart       = "on-failure";
          RestartSec    = 1;
          TimeoutStopSec = 10;
        };
      };

      # Symlink the generated config into the user's home on each activation
      systemd.user.tmpfiles.rules = [
        "L+ %h/.config/hypr/hyprland.conf - - - - ${hyprlandConf}"
      ];

      environment.systemPackages = with pkgs; [
        hyprpicker
        wf-recorder
        grimblast
        slurp
        swappy
        xdotool
        yad
        playerctl
        hyprshot
        jq
      ];
    };
}
