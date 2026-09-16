{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      size = 12.0;
      name = "monospace";
    };
    themeFile = "tokyo_night_moon";
    settings = {
      #General
      strip_trailing_spaces = "smart";
      copy_on_select = "yes";
      confirm_os_window_close = 0;
      scrollback_lines = 1000;
      enable_audio_bell = false;
      mouse_hide_wait = 60;
      update_check_interval = 0;

      #Cursor Trail
      cursor_trail = 3;
      cursor_trail_decay = "0.08 0.3";
      cursor_trail_start_threshold = 4;
      cursor_trail_color = "none";

    };
  };
}
