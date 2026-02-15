{ inputs, lib, pkgs, ... }:
let
  vars = import ./variables.nix;
in
{
  # Make RAPL energy counter readable to user services (avoids: "Failed to open
   # .../energy_uj"). This is a sysfs attribute owned by root.
   systemd.tmpfiles.rules = [
     "z /sys/class/powercap/intel-rapl/intel-rapl:0/intel-rapl:0:0/energy_uj 0444 - - - -"
   ];

  imports = [
     inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series

    ./hardware-configuration.nix
    ./host-packages.nix
    
    ../../modules/programs/cli/tetrigo
    # Core Modules
    ../../modules/scripts
    ../../modules/core

    # Optional
    #../../modules/hardware/drives # Automatically mount extra external/internal drives
    ../../modules/hardware/video/${vars.videoDriver}.nix # Enable gpu drivers defined in variables.nix
    ../../modules/desktop/${vars.desktop} # Set window manager defined in variables.nix
    ../../modules/programs/browser/${vars.browser} # Set browser defined in variables.nix
    ../../modules/programs/terminal/${vars.terminal} # Set terminal defined in variables.nix
    ../../modules/programs/editor/${vars.editor} # Set editor defined in variables.nix
    ../../modules/programs/cli/${vars.tuiFileManager} # Set file-manager defined in variables.nix
    ../../modules/programs/cli/tmux
    ../../modules/programs/editor/vscode
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/git.nix
    ../../modules/programs/cli/cava
    ../../modules/programs/cli/fastfetch
    ../../modules/programs/cli/btop
    ../../modules/programs/media/discord
    # ../../modules/programs/media/spicetify
    ../../modules/programs/media/youtube-music
    ../../modules/programs/misc/cpufreq
    # ../../modules/programs/media/thunderbird
    # ../../modules/programs/media/obs-studio
    ../../modules/programs/media/mpv
    ../../modules/programs/misc/tlp
    #../../modules/programs/misc/thunar
    ../../modules/programs/misc/lact # GPU fan, clock and power configuration
  ]
  ++ lib.optional (vars.games == true) ../../modules/core/games.nix;


  environment.etc."shells".text = ''
    /run/current-system/sw/bin/bash
    /run/current-system/sw/bin/zsh
  '';
}
