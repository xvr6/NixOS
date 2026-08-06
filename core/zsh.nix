{
  pkgs,
  lib,
  self,
  ...
}:
{
  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    histSize = 100000;
    histFile = "$HOME/.local/share/zsh/history";

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "gitignore"
        "z"
      ];
    };

    setOptions = [
      "PROMPT_SUBST"
      "ALWAYS_TO_END"
      "APPEND_HISTORY"
      "AUTO_MENU"
      "COMPLETE_IN_WORD"
      "EXTENDED_HISTORY"
      "HIST_EXPIRE_DUPS_FIRST"
      "HIST_IGNORE_DUPS"
      "HIST_IGNORE_SPACE"
      "HIST_VERIFY"
      "INC_APPEND_HISTORY"
      "SHARE_HISTORY"
    ];

    promptInit = ''
      eval "$(${pkgs.oh-my-posh}/bin/oh-my-posh init zsh --config ${pkgs.oh-my-posh}/share/oh-my-posh/themes/catppuccin_mocha.omp.json)"
    '';

    interactiveShellInit = ''
      # Direnv Hook
      if command -v direnv &>/dev/null; then
        eval "$(direnv hook zsh)"
      fi

      # Key Bindings
      bindkey '^a' beginning-of-line
      bindkey '^e' end-of-line

      unsetopt MENU_COMPLETE
      unsetopt FLOW_CONTROL

      export FZF_DEFAULT_OPTS=" \
      --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
      --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
      --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

      lf() {
        tmp="$(mktemp)"
        command lf -last-dir-path="$tmp" "$@"
        if [ -f "$tmp" ]; then
          dir="$(cat "$tmp")"
          rm -f "$tmp"
          if [ -d "$dir" ] && [ "$dir" != "$(pwd)" ]; then
            cd "$dir"
          fi
        fi
      }

      cdown() {
        N=$1
        while [[ $((--N)) -gt 0 ]]; do
          echo "$N" | figlet -c | lolcat && sleep 1
        done
      }
    '';

    shellAliases = {
      cls = "clear";
      tml = "tmux list-sessions";
      tma = "tmux attach";
      tms = "tmux attach -t $(tmux ls -F '#{session_name}: #{session_path} (#{session_windows} windows)' | fzf | cut -d: -f1)";
      l = "${pkgs.eza}/bin/eza -lh  --icons=auto";
      ls = "${pkgs.eza}/bin/eza -1   --icons=auto";
      ll = "${pkgs.eza}/bin/eza -lha --icons=auto --sort=name --group-directories-first";
      ld = "${pkgs.eza}/bin/eza -lhD --icons=auto";
      tree = "${pkgs.eza}/bin/eza --icons=auto --tree";
      nf = "${pkgs.microfetch}/bin/microfetch";
      ff = "fastfetch";
      cp = "cp -iv";
      mv = "mv -iv";
      rm = "rm -vI";
      bc = "bc -ql";
      mkd = "mkdir -pv";
      tp = "${pkgs.trash-cli}/bin/trash-put";
      tpr = "${pkgs.trash-cli}/bin/trash-restore";
      grep = "grep --color=always";
      list-gens = "nixos-rebuild list-generations";
      find-store-path = "nix-shell -p $1 --command 'nix eval -f \"<nixpkgs>\" --raw $1'";
      update-input = "nix flake update $@";
      sysup = "nix flake update --flake ~/NixOS && rebuild";
      nrs = "sudo nixos-rebuild switch --flake ~/NixOS";
      nrt = "sudo nixos-rebuild test --flake ~/NixOS";
      dots = "cd ~/NixOS/";
      projs = "cd ~/projects/";

      # make easier to call noctalia from own shell
      noctalia = "${lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.myNoctalia}";

      # Packwiz cmds
      prf = "packwiz refresh";
      prh = "packwiz rehash sha512";

      # Git alises
      #TODO: these appear to already exist from some other source? Does git pkg ship with aliases?
      # ga = "git add .";
      # gc

    };
  };
}
