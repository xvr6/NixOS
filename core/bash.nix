{ pkgs, ... }:
{
  programs.bash = {
    completion.enable = true;
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
      update-input = "nix flake update $@";
      sysup = "nix flake update --flake ~/NixOS && rebuild";
      dots = "cd ~/NixOS/";
      projs = "cd ~/projects/";
    };
    shellInit = ''
      shopt -s autocd cdspell cmdhist dotglob histappend expand_aliases checkwinsize

      HISTFILESIZE=100000
      HISTSIZE=100000

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
  };
}
