{ config, ... }: {
  programs.umbriel = {
    settings = {
      keybinds = {
        # Noctalia
        "Mod+Space" = "spawn: noctalia msg panel-toggle launcher";
        "Mod+L" = "spawn: noctalia msg session lock";
        "Mod+Shift+W" = "spawn:noctalia msg panel-toggle wallpaper";
        "Mod+Control+W" = "spawn:noctalia msg panel-toggle noctalia/wallhaven:browser";

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

        # Programs
        "Mod+Return" = "spawn: kitty";
        "Mod+E" = "spawn:nemo";
        "Mod+Shift+Escape" = "spawn:kitty btop";
        "Mod+B" = "spawn: zen";

        #Umbriel window management
        "Mod+Q" = "window-close";
        "Alt+F4" = "window-close";
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

        # - Overview/Output focusing
        "Mod+Alt+Left" = "output-focus-left";
        "Mod+Alt+WheelLeft" = "output-focus-left";
        "Mod+Alt+Right" = "output-focus-right";
        "Mod+Alt+WheelRight" = "output-focus-right";

        "Mod+Tab" = "overview-toggle";
        "Alt+Tab" = "output-focus-next";
        "Alt+Shift+Tab" = "output-focus-previous";

        # - Misc
        "Mod+H" = "cheatsheet-toggle";
      };
    };
  };
}
