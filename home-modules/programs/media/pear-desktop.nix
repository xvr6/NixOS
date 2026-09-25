{ lib, pkgs, ... }:
let
  appId = "com.github.th-ch.youtube-music";
in
{
  # theming handled by the noctalia "pear-desktop" community template
  home.packages = [ pkgs.pear-desktop ];

  # config.json is rewritten by the app itself, so patch the one key in place
  # rather than owning the file: don't resume the last track on launch
  home.activation.pearDesktopNoResume = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    cfg="$HOME/.config/YouTube Music/config.json"
    if [ -f "$cfg" ]; then
      tmp="$(mktemp)"
      ${lib.getExe pkgs.jq} '.options.resumeOnStart = false' "$cfg" >"$tmp" && mv "$tmp" "$cfg"
    else
      mkdir -p "$(dirname "$cfg")"
      echo '{"options":{"resumeOnStart":false}}' >"$cfg"
    fi
  '';

  # Toggleable scratchpad for pear-desktop akin to the noctalia plugin
  programs.umbriel.settings = {
    # launched at login; the window rule sends it straight into the hidden scratchpad
    general.autostart = [ "pear-desktop" ];
    scratchpad = [ { name = "music"; } ];
    window_rule = [
      {
        match.app_id = "^${appId}$";
        opacity = 0.7;
        blur = true;
        default_scratchpad = "music";
        default_floating_size = {
          width = 0.75;
          height = 0.80;
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
