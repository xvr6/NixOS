{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      size = 12.0;
      name = "monospace";
    };
    settings = {
      #General
      strip_trailing_spaces = "smart";
      macos_option_as_alt = "yes";
      macos_quit_when_last_window_closed = true;
      copy_on_select = "yes";
      confirm_os_window_close = 0;
      scrollback_lines = 10000;
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
