{ pkgs, ... }: {
  xdg.configFile."lf/icons".source = ./icons;
  programs.lf = {
    enable = true;
    settings = {
      preview = true;
      drawbox = false;
      hidden = true;
      ignorecase = true;
      icons = true;
    };
    keybindings = {
      m = "";
      d = "";
      "." = "set hidden!";
      "<enter>" = "$vi $f";
      "<space>" = "toggle"; # Select file (v to select all)
      s = "dragon-out"; # Drag and drop
      au = "unarchive";
      dd = "cut";
      dD = "delete";
      # dR = "restore_trash";
      p = "paste";
      x = "cut";
      y = "copy";
      c = "copy";
      R = "reload";
      a = "mkfile";
      A = "mkdir";
      C = "clear";

      gn = "cd ~/NixOS";
      gD = "cd ~/Documents";
      gd = "cd ~/Downloads";
      gp = "cd ~/Projects";
      gv = "cd ~/Videos";
      gt = "cd ~/.local/share/Trash/files";
    };
    commands = {
      dragon-out = ''%${pkgs.dragon-drop} -a -x "$fx"'';
      mkdir = ''
        ''${{
            printf "Directory Name: "
            read ans
            mkdir $ans
          }}
      '';
      mkfile = ''
        ''${{
            printf "File Name: "
            read ans
            touch $ans
          }}
      '';

      unarchive = ''
        ''${{
            case "$f" in
                *.zip|*.7z|*.tar|*.xz|*.gzip) ${pkgs._7zz} x "$f" ;;
                *.rar) ${pkgs.unrar} x "$f" ;;
                *.tar.xz|*.txz) ${pkgs.gnutar} xJvf $f;;
                *.tar.gz|*.tgz) ${pkgs.gnutar} -xzvf "$f" ;;
                *.tar.bz|*.tar.bz2|*.tbz|*.tbz2) ${pkgs.gnutar} -xjvf "$f" ;;
                *) echo "Unsupported format" ;;
            esac
          }}
      '';
    };
  };
}
