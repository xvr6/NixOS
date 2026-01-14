{ pkgs, lib, host, config, ... }:
  let
    inherit (import ../../hosts/${host}/variables.nix) terminal;
  in
    let
      # Define your custom args once
      scriptArgs = {
        inherit
          host
          pkgs
          lib
          config
          terminal
          ;
      };

      scripts = [
        (import ./driverinfo.nix scriptArgs)
        (import ./extract.nix scriptArgs)
        (import ./launcher.nix scriptArgs)
        (import ./network.nix scriptArgs)
        (import ./rollback.nix scriptArgs)
        (import ./tmux-sessionizer.nix scriptArgs)
        # Add new scripts here as you create them
  ];
  in {
    environment.systemPackages = scripts;
  }
