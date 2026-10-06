{ lib, pkgs, ... }:
{
  # theming handled by the noctalia "pear-desktop" community template
  home.packages = [ pkgs.pear-desktop ];

  # Toggleable scratchpad for pear-desktop akin to the noctalia plugin
  programs.umbriel.settings = {
    # launched at login; the window rule sends it straight into the hidden scratchpad
    general.autostart = [ "pear-desktop" ];
    scratchpad = [ { name = "music"; } ];
    window_rule = [
      {
        match.app_id = "^com.github.th-ch.youtube-music$";
        opacity = 0.7;
        blur = true;
        default_scratchpad = "music";
        default_floating_size = {
          width = 0.5;
          height = 0.55;
        };
        default_position = {
          x = 0;
          y = 0;
          anchor = "center";
        };
      }
    ];
    keybinds."Mod+M" = "scratchpad-toggle:music";
  };
}
