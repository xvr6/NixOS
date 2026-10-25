{ pkgs, lib, ... }:

let
  # Per-folder view overrides (default is list). Paths are relative to $HOME.
  # Views: "icon" (grid), "list", "compact". e.g. "Pictures/Photos" = "icon";
  folderViews = {
  };

  viewId = v: "OAFIID:Nemo_File_Manager_${lib.toUpper (builtins.substring 0 1 v)}${builtins.substring 1 (-1) v}_View";
in
{
  home.packages = with pkgs; [
    # superior to `nemo`; comes with context menu dependencies setup and wired.
    nemo-with-extensions
    loupe # image viewer; default for image/* below
    ffmpegthumbnailer # video thumbnails in nemo
  ];

  # kitty-open.desktop claims inode/directory, so `xdg-open <folder>` (used by "open folder"
  # in Prism, etc.) launched a kitty window instead of nemo.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "nemo.desktop";

      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";
      "image/avif" = "org.gnome.Loupe.desktop";
      "image/bmp" = "org.gnome.Loupe.desktop";
      "image/tiff" = "org.gnome.Loupe.desktop";
      "image/svg+xml" = "org.gnome.Loupe.desktop";

      "x-scheme-handler/discord" = "discord.desktop";
      "x-scheme-handler/claude-cli" = "claude-code-url-handler.desktop";
      "x-scheme-handler/tg" = "io.github.kukuruzka165.materialgram.desktop";
      "x-scheme-handler/tonsite" = "io.github.kukuruzka165.materialgram.desktop";

      "application/vnd.ms-publisher" = "kitty-nvim.desktop";
      "application/x-trash" = "kitty-nvim.desktop";

      "application/pdf" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/chrome" = "zen.desktop";
      "text/html" = "zen.desktop";
      "application/x-extension-htm" = "zen.desktop";
      "application/x-extension-html" = "zen.desktop";
      "application/x-extension-shtml" = "zen.desktop";
      "application/xhtml+xml" = "zen.desktop";
      "application/x-extension-xhtml" = "zen.desktop";
      "application/x-extension-xht" = "zen.desktop";
    };
  };

  # Nemo's "Open in Terminal" doesnt default point to kitty
  dconf.settings."org/cinnamon/desktop/applications/terminal" = {
    exec = "kitty";
    exec-arg = "--";
  };

  dconf.settings."org/nemo/preferences".default-folder-viewer = "list-view";

  # Nemo stores per-folder views as gvfs metadata, so overrides must be applied with `gio set`.
  home.activation.nemoFolderViews = lib.hm.dag.entryAfter [ "writeBoundary" ] (
    lib.concatStrings (
      lib.mapAttrsToList (dir: view: ''
        if [ -d "$HOME/${dir}" ]; then
          run ${pkgs.glib.bin}/bin/gio set "$HOME/${dir}" metadata::nemo-default-view ${viewId view} || true
        fi
      '') folderViews
    )
  );

  # Open in neovim action; `nixvim` installed system-wide in modules/core/packages.nix).
  xdg.dataFile."nemo/actions/open-in-nvim.nemo_action".text = ''
    [Nemo Action]
    Active=true
    Name=Edit with Neovim
    Comment=Open the selected file(s)/folder(s) in Neovim
    Exec=kitty --title Neovim -e nvim %F
    Icon-Name=text-editor
    Selection=notnone
    Extensions=any;
    Quote=double
  '';
}
