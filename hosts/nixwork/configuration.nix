{ inputs, lib, ... }:
let
  vars = import ./variables.nix;
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.framework-amd-ai-300-series

    ./hardware-configuration.nix
    ../../modules/hardware/video/${vars.videoDriver}.nix
    ./host-packages.nix
    
    # Core Modules (Don't change unless you know what you're doing)
    ../../modules/scripts
    ../../modules/core

    # Optional
    #../../modules/hardware/drives # Automatically mount extra external/internal drives
    # ../../modules/hardware/video/${vars.videoDriver}.nix # Enable gpu drivers defined in variables.nix
    ../../modules/desktop/${vars.desktop} # Set window manager defined in variables.nix
    ../../modules/programs/browser/${vars.browser} # Set browser defined in variables.nix
    ../../modules/programs/terminal/${vars.terminal} # Set terminal defined in variables.nix
    ../../modules/programs/editor/${vars.editor} # Set editor defined in variables.nix
    ../../modules/programs/cli/${vars.tuiFileManager} # Set file-manager defined in variables.nix
    ../../modules/programs/cli/tmux
    ../../modules/programs/editor/vscode
    ../../modules/programs/cli/direnv
    ../../modules/programs/cli/lazygit
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
  #powerManagement.cpuFreqGovernor = "schedutil";

  environment.etc."shells".text = ''
/run/current-system/sw/bin/bash
/run/current-system/sw/bin/zsh
'';
environment.etc."polkit-1/rules.d/49-gamemode.rules".text = ''
polkit.addRule(function(action, subject) {
    var cmd = action.lookup("command");
    if (action.id == "org.freedesktop.policykit.exec" &&
        cmd && (cmd.indexOf("cpugovctl") !== -1 || cmd.indexOf("procsysctl") !== -1)) {
        if (subject.local && subject.active) {
            return polkit.Result.YES;
        }
    }
});
'';

}
